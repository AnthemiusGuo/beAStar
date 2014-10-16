local LocationScene = class("LocationScene",izx.baseView)

function LocationScene:ctor(pageName,moduleName,initParam)

end


function LocationScene:onAssignVars()

end

function LocationScene:onPressBtn(e)
    print("LocationScene:onPressBtn");
    var_dump(e);
end

return LocationScene;
