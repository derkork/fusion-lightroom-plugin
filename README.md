# Lightroom Fusion Plugin

## What does it do?
This is a plugin for Adobe's Lightroom Classic which allows you to edit photos in Blackmagic Fusion. Technically you don't need this plugin if you just want to edit a photo in Fusion but it automates a few manual steps. You can edit a photo in Fusion by selecting it and then using the `Library` -> `Plugin-Extras` -> `Edit in Fusion` menu entry. The plugin will then do the following steps:

* It will export the selected photo to a TIFF file which serves as input to Fusion.
* It will create a Fusion composition with a loader node that loads the generated TIFF file and a saver node that will save the result in a JPEG file and opens this in Fusion. If a composition already exists (because you edited this photo before) it will open the existing composition.
* It will re-import the JPEG file into your catalog and stack it on top of the original photo.

## How to install and use

You will need Lightroom Classic and Blackmagic Fusion. If you're interested in a Lightroom plugin you will probably already have Lightroom installed. You can download a free version of Fusion 9 or the latest Fusion 16 Studio (non free) from Blackmagic's website.

![Add the Plugin in the plugin manager][/docs/01-add-plugin.png]
![Navigate to the folder.][/docs/02-navigate-and-select.png]
![Configure the path to Fusion.exe][/docs/03-select-fusion-exe.png]
![Edit the photo in Fusion.][/docs/04-edit.png]


## Limitations

* I've only tested this on Windows. It may work on Macs, but I didn't try it.
* Speaking of testing, this has received very little testing. So there are almost certainly bugs in it.
* Currently you can only have one composition per input photo.
* The exported TIFF files are not automatically deleted after you finish editing in Fusion, so you have to delete them manually.
* If you decide you don't want to keep the edit done in Fusion you can delete the JPEG directly from Lightroom but the composition remains. It's a small file but it's still not nice to retain it.

## Why?
To some extent, the answer is "because I can". I wanted to try out a truly non-destructive way of editing photos and Blackmagic Fusion offers such a way.

When you edit in Photoshop, you can be non-destructive to some extent with Photoshop's layers, smart objects and some clever techniques using masks. However at the end of the day, there is always a point where you need to do a destructive change (e.g. when applying a filter). Also all layers with intermediate results get saved into the final Photoshop file, so a photo starting with a modest 50 megabytes of RAW can end up with a 300-600 megabytes TIFF file after editing, even more if you have more layers. Even if storage is cheap, offsite backup storage is not (you do offsite backups for your photos, right?). So I find half a gigabyte per photo to be a bit on the excessive side of things.

If you use Blackmagic Fusion to edit a photo, you get a JPEG as output with all edits burned in. However, you can save the whole Fusion composition alongside the JPEG so you can change your edits later and get a new JPEG with the changed edits. A Fusion composition is only a few kilobytes of data, so instead of having a RAW and a 500MB TIFF at the end like you have with Photoshop, you only end up with a RAW, a JPEG and a small Fusion composition file.  

Also Fusion is truly non-destructive in it's editing. Every edit is a node with instructions and you can change every node later in the process. If you need to refine a selection 3 steps in the process, you can just change the node and you're done. Also all changes to nodes will be directly reflected in the output. It is working very differently from Photoshop and takes some getting used to, but I find it to be a superior experience to working with Photoshop in most cases.

## Pro's and Cons of Photoshop and Fusion for image editing
### Photoshop

**Pros** 

* You know how to use it.
* Tons of tutorials and documentation available.
* Small corrections like removing objects, color corrections, etc. are quickly and easily done.
* Lots of third-party filters are available.

**Cons**

* None-destructive editing is limited to layers and smart objects.
* Complex edits and compositing are more difficult to do.
* Resulting files can be huge.

### Fusion

**Pros**

* Complex edits and compositing can be done more efficiently.
* Node-based system allows you to re-use node outputs for many different purposes (e.g. the same mask can be used for driving multiple effects.)
* Fully non-destructive. You can go back to any node and modify it and immediately see the results everywhere.
* Strong procedural generation features.
* Small file size of composition files.

**Cons**

* Works a lot different from Photoshop, so some learning effort is required to use it efficiently.
* While there is a good documentation coming with it, there aren't many tutorials available online.
* It cannot use Photoshop plugins, so your favourite plugin won't work.
* It was made for visual effects work in movies so working with images is not it's main focus. 


