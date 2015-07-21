Function loadOrganizeMenu(languageName as String, videoType as String) as integer
    print "Selecting language:  tamil"
   
    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    InitTheme()
    screen.SetHeader("Options for language" + languageName + "-" + videoType )
    
    screen.SetBreadcrumbText("Menu", "HD")
    contentList = InitOrganizeMenuContentList()
    if (contentList.Count() > 0)
         screen.SetBreadcrumbText("Menu", contentList[0].Title)
    end if
    
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
                organize =contentList[msg.GetIndex()].Title
                print "Selected organize" + organize
                ShowMovieList( languageName, videoType, organize )
               
                screen.show()
            endif      
        endif
    end while
    
    
    print "Ending Screen for language:  tamil"
    return -1
End Function

Function InitOrganizeMenuContentList() as object
    contentList = [
        {
            Title: "Activity",
            ID: "1",
            SDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDBackgroundImageUrl: "pkg:/images/breakfast_large.png",
            SDBackgroundImageUrl: "pkg:/images/breakfast_large.png",            
            ShortDescriptionLine1: "Organized By Activity",
            ShortDescriptionLine2: "See Movis  By Recent Activities"
        },
        {
            Title: "Cast",
            ID: "2",
            SDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDBackgroundImageUrl: "pkg:/images/lunch_large.png",
            SDBackgroundImageUrl: "pkg:/images/lunch_large.png",            
            ShortDescriptionLine1: "Organized By Cast",
            ShortDescriptionLine2: "See movies By Cast"            
        }
        {
            Title: "Alphabetical",
            ID: "3",
            SDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDBackgroundImageUrl: "pkg:/images/lunch_large.png",
            SDBackgroundImageUrl: "pkg:/images/lunch_large.png",            
            ShortDescriptionLine1: "Organize by Alphabetical",
            ShortDescriptionLine2: "See movies by Alphabetical"            
        }
        {
            Title: "Year",
            ID: "3",
            SDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDBackgroundImageUrl: "pkg:/images/lunch_large.png",
            SDBackgroundImageUrl: "pkg:/images/lunch_large.png",            
            ShortDescriptionLine1: "Organize by Year",
            ShortDescriptionLine2: "See movies by Year"            
        }
        {
            Title: "Director",
            ID: "3",
            SDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDBackgroundImageUrl: "pkg:/images/lunch_large.png",
            SDBackgroundImageUrl: "pkg:/images/lunch_large.png",            
            ShortDescriptionLine1: "Organize by Director",
            ShortDescriptionLine2: "See movies by Year"            
        }
         {
            Title: "Rating",
            ID: "3",
            SDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDBackgroundImageUrl: "pkg:/images/lunch_large.png",
            SDBackgroundImageUrl: "pkg:/images/lunch_large.png",            
            ShortDescriptionLine1: "Organize by Rating",
            ShortDescriptionLine2: "See movies by Rating"            
        }
        
    ]
    return contentList
End Function





