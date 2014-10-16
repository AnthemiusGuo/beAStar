package.loaded["izxFW.BaseFunctions"] = nil
package.loaded["izxFW.MBPluginManager"] = nil
package.loaded["izxFW.PacketDefine"] = nil
package.loaded["izxFW.BaseView"] = nil
package.loaded["izxFW.BasePage"] = nil
package.loaded["izxFW.BaseCtrller"] = nil
package.loaded["izxFW.BasePopup"] = nil
package.loaded["izxFW.AudioManager"] = nil
package.loaded["izxFW.BaseGameLogic"] = nil
package.loaded["izxFW.UTF8"] = nil
package.loaded["izxFW.ResourceManager"] = nil
package.loaded["izxFW.MiniGameManager"] = nil

izx = izx or {};
require("izxFW.BaseFunctions");
require("izxFW.PacketDefine");
izx.baseView = require "izxFW.BaseView";
izx.basePage = require "izxFW.BasePage";
izx.baseCtrller = require "izxFW.BaseCtrller";
izx.basePopup = require "izxFW.BasePopup";
izx.baseAudio = require("izxFW.AudioManager").new();
izx.baseGameLogic = require "izxFW.BaseGameLogic";
izx.UTF8 = require("izxFW.UTF8");
izx.resourceManager = izx.resourceManager or require("izxFW.ResourceManager").new();
izx.miniGameManager = require("izxFW.MiniGameManager").new();
scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
CCJReader = require "izxFW.CCJReader";