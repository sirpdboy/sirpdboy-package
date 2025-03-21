/* Copyright (C) 2024 */

'use strict';
'require form';
'require poll';
'require rpc';
'require uci';
'require view';

var callServiceList = rpc.declare({
    object: 'service',
    method: 'list',
    params: ['name'],
    expect: { '': {} }
});

// 获取虚拟USB服务状态
function getServiceStatus() {
    return L.resolveDefault(callServiceList('vusb'), {}).then(function (res) {
        var isRunning = false;
        try {
            isRunning = res['vusb']['instances']['instance1']['running'];
        } catch (e) { }
        return isRunning;
    });
}

// 渲染服务状态
function renderStatus(isRunning) {
    var spanTemp = '<em><span style="color:%s"><strong>%s %s</strong></span></em>';
    var renderHTML;
    if (isRunning) {
        renderHTML = spanTemp.format('green', _('VirtualHere USB Server'), _('RUNNING'));
    } else {
        renderHTML = spanTemp.format('red', _('VirtualHere USB Server'), _('NOT RUNNING'));
    }
    return renderHTML;
}


return view.extend({
	load: function() {
		return uci.load('vusb');
	},
	
    render: function() {
		var m, s, o;
        m = new form.Map('vusb', _('VirtualHere USB Server'), _('配置虚拟USB服务。将网络设备与本地主机上的USB设备进行映射。<a href="https://github.com/bauw2008/op/tree/master/luci-app-vusb">仓库地址</a>，<a id="client-software-link" href="http://www.virtualhere.com/usb_client_software">客户端下载</a>，并根据本地主机架构进行安装。<br>注册码（x86、arm64无效）：xxxxxxxxxxxx，999，MCACDkn0jww6R5WOIjFqU/apAg4Um+mDkU2TBcC7fA1FrA=='));
        
        // 添加状态显示区域
        s = m.section(form.TypedSection);
        s.anonymous = true;
        s.render = function () {
            poll.add(function () {
                return getServiceStatus().then(function (res) {
                    var view = document.getElementById('vusb_status');
                    view.innerHTML = renderStatus(res);
                });
            });

            return E('div', { class: 'cbi-section', id: 'status_bar' }, [
                E('p', { id: 'vusb_status' }, _('Collecting data...'))
            ]);
        }
        
        // 添加配置区域
        s = m.section(form.NamedSection, 'config', 'vusb');
        // 添加启用开关选项
        o = s.option(form.Flag, 'enabled', _('启用'));
        o.default = o.disabled;
        o.rmempty = false;
		
		// 添加端口号设置选项
        // o = s.option(form.Value, 'port', _('端口'));
        // o.default = '7575'; // 默认端口号为7575
        // o.placeholder = '请输入端口号'; // 输入框的占位符
  
        // 添加IPv6接口开关选项
        o = s.option(form.Flag, 'ipv6', _('IPv6'));
        o.default = o.disabled;
        o.rmempty = false;
		
		// 添加外网访问开关选项
        // o = s.option(form.Flag, 'web', _('外网访问-firewall4'));
        // o.default = o.disabled;
        // o.rmempty = false;

        // 返回渲染结果
        return m.render();
    }
});
