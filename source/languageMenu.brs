Function CreateTamilMenu(screen as object) as integer
    print "Selecting language:  tamil"
    ShowLanguageItemDetails( "Tamil" )
    print "Ending Screen for language:  tamil"
    return -1
End Function

Function CreateTeluguMenu(screen as object) as integer
    print "Selecting language:  Telugu"
    ShowLanguageItemDetails( "Telugu" )
    return -1
End Function


Function CreateHindiMenu(screen as object) as integer
    print "Selecting language:  Hindi"
    ShowLanguageItemDetails( "Hindi" )
    return -1
End Function

Function CreateMalayalamMenu(screen as object) as integer
    print "Selecting language:  Malayalam"
    ShowLanguageItemDetails( "Malayalam" )
    return -1
    
End Function




Function ShowLanguageItemDetails(languageName as String) as integer
    print "Selected language: " + languageName
     m.submenuFunctions = [
        ShowHDList,
        ShowBluRayList
    ]
    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    InitTheme()
    screen.SetHeader("Options for language" + languageName )
    screen.SetBreadcrumbText("Menu", "HD")
    contentList = InitLanguageContentList()
    screen.SetContent(contentList)
    screen.show()
    while (true)
        msg = wait(0, port)
        if (type(msg) = "roListScreenEvent")
             if (msg.isScreenClosed())
                print "language screen is closing"
                return -1
            else if (msg.isListItemFocused())
                screen.SetBreadcrumbText("Menu", contentList[msg.GetIndex()].Title)
            else if (msg.isListItemSelected())
                videoType = contentList[msg.GetIndex()].Title
                print "loading videoType" + videoType
                loadOrganizeMenu(languageName, videoType)
                print "After language option  screen is loaded"
                screen.show()
            endif      
        endif
    end while
    
   
End Function



Function InitLanguageContentList() as object
    contentList = [
        {
            Title: "HD",
            ID: "1",
            SDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDBackgroundImageUrl: "pkg:/images/breakfast_large.png",
            SDBackgroundImageUrl: "pkg:/images/breakfast_large.png",            
            ShortDescriptionLine1: "HD Videos",
            ShortDescriptionLine2: "Select from our HD Videos"
        },
        {
            Title: "BLURAY",
            ID: "2",
            SDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDBackgroundImageUrl: "pkg:/images/lunch_large.png",
            SDBackgroundImageUrl: "pkg:/images/lunch_large.png",            
            ShortDescriptionLine1: "BluRay Videos",
            ShortDescriptionLine2: "Select from our BluRay Videos"            
        }
        
    ]
    return contentList
End Function



