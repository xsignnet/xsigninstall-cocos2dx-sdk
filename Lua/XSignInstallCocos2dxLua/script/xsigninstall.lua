
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

local xsigninstall = class("xsigninstall")

local activityClassName = cc.PLATFORM_OS_ANDROID == targetPlatform and "io/xsigninstall/cocos2dx/XSignInstallInterface" or "XSignInstallBridge"

function xsigninstall:reportRegister()
	print("call reportRegister start")
	if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
		local args = {}
		local signs = "()V"
		local ok,ret = luaj.callStaticMethod(activityClassName, "reportRegister", args, signs)
		if not ok then
            print("call reportRegister fail" .. ret)
		end
	end
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local luaoc = require "cocos.cocos2d.luaoc"
        local ok, ret = luaoc.callStaticMethod(activityClassName, "reportRegister")
        if not ok then
            print("luaoc reportRegister error:" .. ret)
        end
    end
end

function xsigninstall:getInstall(callback)
    print("call getInstall start")
	if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
		local args = {callback}
		local signs = "(I)V"
		local ok,ret = luaj.callStaticMethod(activityClassName, "getInstall", args, signs)
		if not ok then
			print("call getInstall fail" .. ret)
		end
	end
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local luaoc = require "cocos.cocos2d.luaoc"
        local args = {callback = callback}
        local ok, ret = luaoc.callStaticMethod(activityClassName, "getInstall", args)
        if not ok then
            print("luaoc getInstall error:" .. ret)
        end
    end
end

function xsigninstall:registerWakeupCallback(callback)
	print("call registerWakeupCallback start")
	if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
		local args = {callback}
		local signs = "(I)V"
		local ok,ret = luaj.callStaticMethod(activityClassName, "registerWakeupCallback", args, signs)
		if not ok then
			print("call registerWakeupCallback fail" .. ret)
		end
	end
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local luaoc = require "cocos.cocos2d.luaoc"
        local args = {callback = callback}
        local ok, ret = luaoc.callStaticMethod(activityClassName, "registerWakeupCallback", args)
        if not ok then
            print("luaoc registerWakeupCallback error:" .. ret)
        end
    end
end

return xsigninstall
