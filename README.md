#  README

This has been built using XCode 10.  Files may need recompiling if you are not using XCode 10, even to run the Playground. Build both HKTFramework and HKTBlogFramework.  It's not necessary to run Sourcery to do the build -- in the Build Settings set RUNSOURCERY to NO to not run Sourcery.

You'll need to run Sourcery if you want to add your own types. Set RUNSOURCERY = YES. 
This project uses Sourcery as a Podfile.  I have set up a build phase to turn the '.stencil' file into generated Swift code. The output file is placed into the Sourcery directory.

Note that the ordering of the generated sourcery.generated.swift file is key -- it needs to be placed in the Build Phases so that it compiles before any of the files using the created classes. This project already has that set up.
