#!/bin/sh
#
# 用于阿里云解析的DNS更新脚本
# 阿里云解析API文档 https://help.aliyun.com/document_detail/29739.html
#
# 本脚本由 dynamic_dns_functions.sh 内的函数 send_update() 调用
#
# 需要在 /etc/config/ddns 中设置的选项
# option username - 阿里云API访问账号 Access Key ID。可通过 aliyun.com 帐号管理的 accesskeys 获取, 或者访问 https://ak-console.aliyun.com
# option password - 阿里云API访问密钥 Access Key Secret
# option domain   - 完整的域名。建议主机与域名之间使用 @符号 分隔，否则将以第一个 .符号 之前的内容作为主机名
#

# 检查传入参数
[ -z "$username" ] && write_log 14 "Configuration error! The 'username' that holds the Alibaba Cloud API access account cannot be empty"
[ -z "$password" ] && write_log 14 "Configuration error! The 'password' that holds the Alibaba Cloud API access account cannot be empty"

# 检查外部调用工具
[ -n "$CURL_SSL" ] || write_log 13 "Alibaba Cloud API communication require cURL with SSL support. Please install"
[ -n "$CURL_PROXY" ] || write_log 13 "cURL: libcurl compiled without Proxy support"
command -v sed >/dev/null 2>&1 || write_log 13 "Sed support is required to use Alibaba Cloud API, please install first"
command -v openssl >/dev/null 2>&1 || write_log 13 "Openssl-util support is required to use Alibaba Cloud API, please install first"

# 变量声明
local __HOST __DOMAIN __TYPE __CMDBASE __RECID __TTL

# 从 $domain 分离主机和域名
[ "${domain:0:2}" = "@." ] && domain="${domain/./}" # 主域名处理
[ "$domain" = "${domain/@/}" ] && domain="${domain/./@}" # 未找到分隔符，兼容常用域名格式
__HOST="${domain%%@*}"
__DOMAIN="${domain#*@}"
[ -z "$__HOST" -o "$__HOST" = "$__DOMAIN" ] && __HOST=@

# 设置记录类型
[ $use_ipv6 = 0 ] && __TYPE=A || __TYPE=AAAA

# 构造基本通信命令
build_command(){
	__CMDBASE="$CURL -Ss"
	# 绑定用于通信的主机/IP
	if [ -n "$bind_network" ];then
		local __DEVICE
		network_get_physdev __DEVICE $bind_network || write_log 13 "Can not detect local device using 'network_get_physdev $bind_network' - Error: '$?'"
		write_log 7 "Force communication via device '$__DEVICE'"
		__CMDBASE="$__CMDBASE --interface $__DEVICE"
	fi
	# 强制设定IP版本
	if [ $force_ipversion = 1 ];then
		[ $use_ipv6 = 0 ] && __CMDBASE="$__CMDBASE -4" || __CMDBASE="$__CMDBASE -6"
	fi
	# 设置CA证书参数
	if [ $use_https = 1 ];then
		if [ "$cacert" = IGNORE ];then
			__CMDBASE="$__CMDBASE --insecure"
		elif [ -f "$cacert" ];then
			__CMDBASE="$__CMDBASE --cacert $cacert"
		elif [ -d "$cacert" ];then
			__CMDBASE="$__CMDBASE --capath $cacert"
		elif [ -n "$cacert" ];then
			write_log 14 "No valid certificate(s) found at '$cacert' for HTTPS communication"
		fi
	fi
	# 如果没有设置，禁用代理 (这可能是 .wgetrc 或环境设置错误)
	[ -z "$proxy" ] && __CMDBASE="$__CMDBASE --noproxy '*'"
}

# 百分号编码
percentEncode(){
	if [ -z "${1//[A-Za-z0-9_.~-]/}" ];then
		echo -n "$1"
	else
		local string=$1;local i=0;local ret chr
		while [ $i -lt ${#string} ];do
			chr=${string:$i:1}
			[ -z "${chr#[^A-Za-z0-9_.~-]}" ] && chr=$(printf '%%%02X' "'$chr")
			ret="$ret$chr"
			i=$(( $i + 1 ))
		done
		echo -n "$ret"
	fi
}

# 用于阿里云API的通信函数
aliyun_transfer(){
	__CNT=0;__URLARGS=
	[ $# = 0 ] && write_log 12 "'aliyun_transfer()' Error - wrong number of parameters"
	# 添加请求参数
	for string in $*;do
		case "${string%%=*}" in
			Format|Version|AccessKeyId|SignatureMethod|Timestamp|SignatureVersion|SignatureNonce|Signature);; # 过滤公共参数
			*)__URLARGS="$__URLARGS&"$(percentEncode "${string%%=*}")"="$(percentEncode "${string#*=}");;
		esac
	done
	__URLARGS="${__URLARGS:1}"
	# 附加公共参数
	string="Format=JSON";__URLARGS="$__URLARGS&"$(percentEncode "${string%%=*}")"="$(percentEncode "${string#*=}")
	string="Version=2015-01-09";__URLARGS="$__URLARGS&"$(percentEncode "${string%%=*}")"="$(percentEncode "${string#*=}")
	string="AccessKeyId=$username";__URLARGS="$__URLARGS&"$(percentEncode "${string%%=*}")"="$(percentEncode "${string#*=}")
	string="SignatureMethod=HMAC-SHA1";__URLARGS="$__URLARGS&"$(percentEncode "${string%%=*}")"="$(percentEncode "${string#*=}")
	string="Timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ');__URLARGS="$__URLARGS&"$(percentEncode "${string%%=*}")"="$(percentEncode "${string#*=}")
	string="SignatureVersion=1.0";__URLARGS="$__URLARGS&"$(percentEncode "${string%%=*}")"="$(percentEncode "${string#*=}")
	string="SignatureNonce="$(cat '/proc/sys/kernel/random/uuid');__URLARGS="$__URLARGS&"$(percentEncode "${string%%=*}")"="$(percentEncode "${string#*=}")
	string="Line=default";__URLARGS="$__URLARGS&"$(percentEncode "${string%%=*}")"="$(percentEncode "${string#*=}")
	# 对请求参数进行排序，用于生成签名
	string=$(echo -n "$__URLARGS" | sed 's/\'"&"'/\n/g' | sort | sed ':label; N; s/\n/\'"&"'/g; b label')
	# 构造用于计算签名的字符串
	string="GET&"$(percentEncode "/")"&"$(percentEncode "$string")
	# 字符串计算签名值
	local signature=$(echo -n "$string" | openssl dgst -sha1 -hmac "$password&" -binary | openssl base64)
	# 附加签名参数
	string="Signature=$signature";__URLARGS="$__URLARGS&"$(percentEncode "${string%%=*}")"="$(percentEncode "${string#*=}")
	__A="$__CMDBASE 'https://alidns.aliyuncs.com/?$__URLARGS'"
	write_log 7 "#> $__A"
	while ! __TMP=`eval $__A 2>&1`;do
		write_log 3 "[$__TMP]"
		if [ $VERBOSE -gt 1 ];then
			write_log 4 "Transfer failed - detailed mode: $VERBOSE - Do not try again after an error"
			return 1
		fi
		__CNT=$(( $__CNT + 1 ))
		[ $retry_count -gt 0 -a $__CNT -gt $retry_count ] && write_log 14 "Transfer failed after $retry_count retries"
		write_log 4 "Transfer failed - $__CNT Try again in $RETRY_SECONDS seconds"
		sleep $RETRY_SECONDS &
		PID_SLEEP=$!
		wait $PID_SLEEP
		PID_SLEEP=0
	done
	__ERR=`jsonfilter -s "$__TMP" -e "@.Code"`
	[ -z "$__ERR" ] && return 0
	case $__ERR in
		LastOperationNotFinished)printf "%s\n" " $(date +%H%M%S)       : 最后一次操作未完成,2秒后重试" >> $LOGFILE;return 1;;
		InvalidTimeStamp.Expired)printf "%s\n" " $(date +%H%M%S)       : 时间戳错误,2秒后重试" >> $LOGFILE;return 1;;
		InvalidAccessKeyId.NotFound)__ERR="无效AccessKey ID";;
		SignatureDoesNotMatch)__ERR="无效AccessKey Secret";;
		InvalidDomainName.NoExist)__ERR="无效域名";;
	esac
	local A="$(date +%H%M%S) ERROR : [$__ERR] - 终止进程"
	logger -p user.err -t ddns-scripts[$$] $SECTION_ID: ${A:15}
	printf "%s\n" " $A" >> $LOGFILE
	exit 1
}

# 添加解析记录
add_domain(){
	while ! aliyun_transfer "Action=AddDomainRecord" "DomainName=$__DOMAIN" "RR=$__HOST" "Type=$__TYPE" "Value=$__IP";do
		sleep 2
	done
	printf "%s\n" " $(date +%H%M%S)       : 添加解析记录成功: [$([ "$__HOST" = @ ] || echo $__HOST.)$__DOMAIN],[IP:$__IP]" >> $LOGFILE
}

# 启用解析记录
enable_domain(){
	while ! aliyun_transfer "Action=SetDomainRecordStatus" "RecordId=$__RECID" "Status=Enable";do
		sleep 2
	done
	printf "%s\n" " $(date +%H%M%S)       : 启用解析记录成功" >> $LOGFILE
}

# 修改解析记录
update_domain(){
	while ! aliyun_transfer "Action=UpdateDomainRecord" "RecordId=$__RECID" "RR=$__HOST" "Type=$__TYPE" "Value=$__IP" "TTL=$__TTL";do
		sleep 2
	done
	printf "%s\n" " $(date +%H%M%S)       : 修改解析记录成功: [$([ "$__HOST" = @ ] || echo $__HOST.)$__DOMAIN],[IP:$__IP],[TTL:$__TTL]" >> $LOGFILE
}

# 获取子域名解析记录列表
describe_domain(){
	ret=0
	while ! aliyun_transfer "Action=DescribeSubDomainRecords" "SubDomain=$__HOST.$__DOMAIN" "Type=$__TYPE";do
		sleep 2
	done
	__TMP=`jsonfilter -s "$__TMP" -e "@.DomainRecords.Record[@]"`
	if [ -z "$__TMP" ];then
		printf "%s\n" " $(date +%H%M%S)       : 解析记录不存在: [$([ "$__HOST" = @ ] || echo $__HOST.)$__DOMAIN]" >> $LOGFILE
		ret=1
	else
		__STATUS=`jsonfilter -s "$__TMP" -e "@.Status"`
		__RECIP=`jsonfilter -s "$__TMP" -e "@.Value"`
		if [ "$__STATUS" != ENABLE ];then
			printf "%s\n" " $(date +%H%M%S)       : 解析记录被禁用" >> $LOGFILE
			ret=$(( $ret | 2 ))
		fi
		if [ "$__RECIP" != "$__IP" ];then
			__TTL=`jsonfilter -s "$__TMP" -e "@.TTL"`
			printf "%s\n" " $(date +%H%M%S)       : 解析记录需要更新: [解析记录IP:$__RECIP] [本地IP:$__IP]" >> $LOGFILE
			ret=$(( $ret | 4 ))
		fi
	fi
}

build_command
describe_domain
if [ $ret = 0 ];then
	printf "%s\n" " $(date +%H%M%S)       : 解析记录不需要更新: [解析记录IP:$__RECIP] [本地IP:$__IP]" >> $LOGFILE
elif [ $ret = 1 ];then
	sleep 3
	add_domain
else
	__RECID=`jsonfilter -s "$__TMP" -e "@.RecordId"`
	[ $(( $ret & 2 )) -ne 0 ] && sleep 3 && enable_domain
	[ $(( $ret & 4 )) -ne 0 ] && sleep 3 && update_domain
fi

return 0
