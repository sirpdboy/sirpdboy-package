/*
 *  luci-theme-kucat
 *  Copyright (C) 2019-2024 The Sirpdboy Team <herboy2008@gmail.com> 
 *
 *  Have a bug? Please create an issue here on GitHub!
 *      https://github.com/sirpdboy/luci-theme-kucat/issues
 *
 *  luci-theme-bootstrap:
 *      Copyright 2008 Steven Barth <steven@midlink.org>
 *      Copyright 2008 Jo-Philipp Wich <jow@openwrt.org>
 *      Copyright 2012 David Menting <david@nut-bolt.nl>
 *
 *  luci-theme-material:
 *      https://github.com/LuttyYang/luci-theme-material/
 *  luci-theme-argon:
 *      https://github.com/jerrykuku/luci-theme-argon
 *  luci-theme-opentopd:
 *      https://github.com/sirpdboy/luci-theme-opentopd
 *
 *  Licensed to the public under the Apache License 2.0
 */


/*
 *  Font generate by Icomoon<icomoon.io>
 */
(function ($) {
    $(".main > .loading").fadeOut();

    /**
     * trim text, Remove spaces, wrap
     * @param text
     * @returns {string}
     */
    function trimText(text) {
        return text.replace(/[ \t\n\r]+/g, " ");
    }

// define what element should be observed by the observer
// and what types of mutations trigger the callback
    const observer = new MutationObserver(() => {
    console.log("callback that runs when observer is triggered");
    });
    if ($("#cbi-dhcp-lan-ignore").length > 0) {
        observer.observe(document.getElementById("cbi-dhcp-lan-ignore"), {
            subtree: true,
            attributes: true
        });
    }

    $(".cbi-button-up").val("");
    $(".cbi-button-down").val("");

    /**
     * hook other "A Label" and add hash to it.
     */
    $("#maincontent > .container").find("a").each(function () {
        var that = $(this);
        var onclick = that.attr("onclick");
        if (onclick == undefined || onclick == "") {
            that.click(function () {
                var href = that.attr("href");
                if (href.indexOf("#") == -1) {
                    $(".main > .loading").fadeIn("fast");
                    return true;
                }
            });
        }
    });

    /**
     * fix legend position
     */
    $("legend").each(function () {
        var that = $(this);
        that.after("<span class='panel-title'>" + that.text() + "</span>");
    });

    $(".cbi-section-table-titles, .cbi-section-table-descr, .cbi-section-descr").each(function () {
        var that = $(this);
        if (that.text().trim() == "") {
            that.css("padding", "0px");
        }
    });

    $(".node-main-login > .main .cbi-value.cbi-value-last .cbi-input-text").focus(function () {
        //$(".node-main-login > .main > .main-right > .login-bg").addClass("blur");
    });
    $(".node-main-login > .main .cbi-value.cbi-value-last .cbi-input-text").blur(function () {
        //$(".node-main-login > .main > .main-right > .login-bg").removeClass("blur");
    });

    $(".main-right").focus();
    $(".main-right").blur();
    $("input").attr("size", "0");

})(jQuery);
function pdopenbar() {
    document.getElementById("header-bar-left").style.width = "300px";
    document.getElementById("header-bar-left").style.display = "block";
    document.getElementById("header-bar-right").style.width = "0";
    document.getElementById("header-bar-right").style.display = "none"
}
function pdclosebar() {
    document.getElementById("header-bar-left").style.display = "none";
    document.getElementById("header-bar-left").style.width = "0";
    document.getElementById("header-bar-right").style.display = "block";
    document.getElementById("header-bar-right").style.width = "50px"
}

    /**
     * Sidebar expand
     */
    var showSide = false;
    $(".showSide").click(function () {
        if (showSide) {
            $(".darkMask").stop(true).fadeOut("fast");
            $(".main-left").width(0);
            $(".main-right").css("overflow-y", "auto");
            showSide = false;
        } else {
            $(".darkMask").stop(true).fadeIn("fast");
            $(".main-left").width("17rem");
            $(".main-right").css("overflow-y", "hidden");
            showSide = true;
        }
    });

    $(".darkMask").click(function () {
        if (showSide) {
            showSide = false;
            $(".darkMask").stop(true).fadeOut("fast");
            $(".main-left").width(0);
            $(".main-right").css("overflow-y", "auto");
        }
    });

    $(window).resize(function () {
        if ($(window).width() > 921) {
            $(".main-left").css("width", "");
            $(".darkMask").stop(true);
            $(".darkMask").css("display", "none");
            showSide = false;
        }
    });
