local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'
local LrBinding = import 'LrBinding'
local prefs = import 'LrPrefs'.prefsForPlugin()

local bind = LrView.bind

local function sectionsForTopOfDialog(f, properties)

    
    properties.fusion_exe = prefs.fusion_exe


   return {
        -- Section for the top of the dialog.
        {
            title = LOC "$$$/Fusion/PluginManager=Fusion Settings",
            f:row {
                f:static_text {
                    title = LOC "$$$/Fusion/PluginManager/FusionExe=Location of Fusion Executable",
                },
            },
            f:row {
                f:edit_field {
                    enabled = false,
                    bind_to_object = properties,
                    fill_horizontal = 1,
                    value = bind 'fusion_exe',
                },

                f:push_button {
                    width = 50,
                    title = LOC "$$$/Fusion/PluginManager/SelectButton=...",
                    enabled = true,
                    action = function()
                        local result = LrDialogs.runOpenPanel {
                            title = LOC "$$$/Fusion/PluginManager/FusionExe/Title=Select Fusion executable",
                            prompt = LOC "$$$/Fusion/PluginManager/FusionExe/Prompt=Select",
                            canChooseFiles = true,
                            canChooseDirectories = false,
                            allowsMultipleSelection = false,
                            fileTypes = { "exe" }, 
                        }

                        if result ~= nil then
                            properties.fusion_exe = result[1]
                            prefs.fusion_exe = properties.fusion_exe
                        end
                    end
                },

            },

        },

    }
end

return {
    sectionsForTopOfDialog = sectionsForTopOfDialog
}

