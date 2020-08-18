local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local catalog = LrApplication.activeCatalog()
local LrTasks = import "LrTasks"
local LrExportSession = import "LrExportSession"
local LrPathUtils = import "LrPathUtils"
local prefs = import 'LrPrefs'.prefsForPlugin()
local LrShell = import 'LrShell';
local LrFileUtils = import 'LrFileUtils'

--- Exports a single photo with the given settings.
function exportSinglePhotoWithSettings(targetPhoto, exportSettings)
    local session = LrExportSession({
        photosToExport = { targetPhoto },
        exportSettings = exportSettings
    })

    local inputName
    -- it will always be just one rendition
    for _, rendition in session:renditions() do
        inputName = rendition.destinationPath
    end

    -- Run the session
    session:doExportOnCurrentTask()

    return inputName
end

-- Exports the given photo to a TIFF file without reimport or stacking. Returns the
-- path to the TIFF file.
function exportToTiff(targetPhoto)
    local exportSettings = {
        LR_collisionHandling = "skip",
        LR_embeddedMetadataOption = "all",
        LR_exportServiceProvider = "com.adobe.ag.export.file",
        LR_export_bitDepth = 16,
        LR_export_colorSpace = "ProPhotoRGB",
        LR_export_destinationPathSuffix = "",
        LR_export_destinationType = "sourceFolder",
        LR_export_photoSectionsEnabled = true,
        LR_export_postProcessing = "doNothing",
        LR_export_useParentFolder = false,
        LR_export_useSubfolder = false,
        LR_extensionCase = "lowercase",
        LR_format = "TIFF",
        LR_includeFaceTagsAsKeywords = true,
        LR_includeFaceTagsInIptc = true,
        LR_includeVideoFiles = false,
        LR_initialSequenceNumber = 1,
        LR_outputSharpeningOn = false,
        LR_reimportExportedPhoto = false,
        LR_reimport_stackWithOriginal = false,
        LR_removeFaceMetadata = true,
        LR_removeLocationMetadata = true,
        LR_renamingTokensOn = true,
        LR_size_doConstrain = false,
        LR_size_percentage = 100,
        LR_size_resolution = 240,
        LR_size_resolutionUnits = "inch",
        LR_tiff_compressionMethod = "compressionMethod_ZIP",
        LR_tiff_preserveTransparency = false,
        LR_tokenCustomString = "",
        LR_tokens = "{{image_originalName}}__fusion_copy",
        LR_tokensArchivedToString2 = {
            {
                menu = {
                    {
                        title = "Filename",
                        value = "image_name",
                    },
                    {
                        title = "Filename number suffix",
                        value = "image_filename_number_suffix",
                    },
                },
                title = "Filename",
                value = "image_name",
            },
        },
        LR_useWatermark = false,
    }

    return exportSinglePhotoWithSettings(targetPhoto, exportSettings)
end


-- Exports the given photo as Jpeg and immediately reimports it.
function exportAnReimportAsJpeg(targetPhoto)
    local exportSettings = {
        collisionHandling = "skip",
        embeddedMetadataOption = "all",
        exportServiceProvider = "com.adobe.ag.export.file",
        export_colorSpace = "ProPhotoRGB",
        export_destinationPathSuffix = "",
        export_destinationType = "sourceFolder",
        export_photoSectionsEnabled = true,
        export_postProcessing = "doNothing",
        export_useParentFolder = false,
        export_useSubfolder = false,
        export_videoFileHandling = "exclude",
        extensionCase = "lowercase",
        format = "JPEG",
        includeFaceTagsAsKeywords = false,
        includeFaceTagsInIptc = false,
        includeVideoFiles = false,
        initialSequenceNumber = 1,
        jpeg_limitSize = 100,
        jpeg_quality = 0.952,
        jpeg_useLimitSize = false,
        metadata_keywordOptions = "flat",
        outputSharpeningOn = false,
        reimportExportedPhoto = true,
        reimport_stackWithOriginal = true,
        reimport_stackWithOriginal_position = "above",
        renamingTokensOn = true,
        size_doConstrain = false,
        size_percentage = 100,
        size_resolution = 4,
        size_resolutionUnits = "cm",
        tokenCustomString = "",
        tokens = "{{image_originalName}}__fusion_edit0000",
        tokensArchivedToString2 = "{{image_name}}",
        useWatermark = false
    }

    local session = LrExportSession({
        photosToExport = { targetPhoto },
        exportSettings = exportSettings
    })

    return exportSinglePhotoWithSettings(targetPhoto, exportSettings)
end

function makeCompFile(width, height, inputName, outputName, compName)
    -- This is the template for the comp file.
    local compTemplate = [[
        Composition {
            CurrentTime = 0,
            RenderRange = { 0, 0 },
            GlobalRange = { 0, 0 },
            CurrentID = 3,
            HiQ = true,
            PlaybackUpdateMode = 0,
            SavedOutputs = 0,
            HeldTools = 0,
            DisabledTools = 0,
            LockedTools = 0,
            AudioOffset = 0,
            Resumable = true,
            Prefs = {
		        Comp = {
            	    FrameFormat = {
		                Width = ###PHOTO_WIDTH###,
                        Height = ###PHOTO_HEIGHT###,
                     }
                }
            },
            Tools = {
                Loader1 = Loader {
                    Clips = {
                        Clip {
                            ID = "Clip1",
                            Filename = "###INPUT_FILE###",
                            FormatID = "TiffFormat",
                            StartFrame = -1,
                            LengthSetManually = true,
                            TrimIn = 0,
                            TrimOut = 0,
                            ExtendFirst = 0,
                            ExtendLast = 0,
                            Loop = 0,
                            AspectMode = 0,
                            Depth = 0,
                            TimeCode = 0,
                            GlobalStart = 0,
                            GlobalEnd = 0
                        }
                    },
                    Inputs = {
                        ["Gamut.SLogVersion"] = Input { Value = FuID { "SLog2" }, },
                    },
                    ViewInfo = OperatorInfo { Pos = { 125.333, 81.9091 } },
                },
                Saver1 = Saver {
                    CtrlWZoom = false,
                    Inputs = {
                        ProcessWhenBlendIs00 = Input { Value = 0, },
                        Clip = Input {
                            Value = Clip {
                                Filename = "###OUTPUT_FILE###",
                                FormatID = "JpegFormat",
                                Length = 0,
                                Saving = true,
                                TrimIn = 0,
                                ExtendFirst = 0,
                                ExtendLast = 0,
                                Loop = 1,
                                AspectMode = 0,
                                Depth = 0,
                                GlobalStart = -2000000000,
                                GlobalEnd = 0
                            },
                        },
                        OutputFormat = Input { Value = FuID { "JpegFormat" }, },
                        ["Gamut.SLogVersion"] = Input { Value = FuID { "SLog2" }, },
                        Input = Input {
                            SourceOp = "Loader1",
                            Source = "Output",
                        },
                        ["JpegFormat.Quality"] = Input { Value = 97, },
                    },
                    ViewInfo = OperatorInfo { Pos = { 292.667, 83.1212 } },
                }
            },

        }
        ]]

    compTemplate = compTemplate:gsub("###PHOTO_WIDTH###", width)
    compTemplate = compTemplate:gsub("###PHOTO_HEIGHT###", height)
    compTemplate = compTemplate:gsub("###INPUT_FILE###", inputName:gsub('\\', '\\\\'))
    compTemplate = compTemplate:gsub("###OUTPUT_FILE###", outputName:gsub('\\', '\\\\'))

    local compFile = io.open(compName, "w")
    compFile:write(compTemplate)
    compFile:close()
end

local targetPhoto = catalog.targetPhoto
if targetPhoto ~= nil then
    LrTasks.startAsyncTask(function()

        -- Export the photo to a TIFF and get the exported file's name.
        local inputName = exportToTiff(targetPhoto)
        -- Export the photo as JPEG, reimport it and stack with the original.
        local outputName = exportAnReimportAsJpeg(targetPhoto)

        -- Build the name of the comp file, based on the input photo's name.
        local compName = LrPathUtils.replaceExtension(targetPhoto:getRawMetadata("path"), "comp")
        local width = targetPhoto:getRawMetadata("width")
        local height = targetPhoto:getRawMetadata("height")

        -- Create the comp file if it doesn't exist, yet
        if not LrFileUtils.exists(compName) then
            makeCompFile(width, height, inputName, outputName, compName)
        end

        -- And open the comp in Fusion
        LrShell.openFilesInApp({ compName }, prefs.fusion_exe)
    end)
end
