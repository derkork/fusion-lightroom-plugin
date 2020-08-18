
return {
	
	LrSdkVersion = 8.0,
	LrSdkMinimumVersion = 8.0,

	LrToolkitIdentifier = 'com.ancientlightstudios.lightroom.plugins.fusion',

	LrPluginName = LOC "$$$/Fusion/PluginName=Fusion",
	
    LrPluginInfoProvider =  "SetupDialog.lua",
    
    -- Add the menu item to the Library menu.
	LrLibraryMenuItems = {
	    {
		    title = LOC "$$$/Fusion/EditInFusion=Edit in Fusion",
            file = "EditInFusionDialog.lua",
            enabledWhen = "photosSelected"
		}
	},
	VERSION = { major=0, minor=0, revision=1 }

}