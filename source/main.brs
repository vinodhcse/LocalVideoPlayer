Function Main() as void
    m.menuFunctions = [
        CreateTamilMenu,
        CreateTeluguMenu,
        CreateHindiMenu,
        CreateMalayalamMenu
    ]
    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    InitTheme()
    screen.SetHeader("Welcome to The Local Video Service")
    screen.SetBreadcrumbText("Menu", "Tamil")
    contentList = InitContentList()
    screen.SetContent(contentList)
    screen.show()
    while (true)
        print "screen in home page"
        msg = wait(0, port)
        if (type(msg) = "roListScreenEvent")
             if (msg.isScreenClosed())
                print "app is exiting"
                Exit While
            else if (msg.isListItemFocused())
               ' stop
                screen.SetBreadcrumbText("Menu", contentList[msg.GetIndex()].Title)
            else if (msg.isListItemSelected())
                'stop
                m.menuFunctions[msg.GetIndex()](screen)
            endif      
        endif
    end while
End Function

Function InitTheme() as void
    app = CreateObject("roAppManager")
    
    listItemHighlight           = "#FFFFFF"
    listItemText                = "#707070"
    brandingGreen               = "#37491D"
    backgroundColor             = "#e0e0e0"
    theme = {
        BackgroundColor: backgroundColor
        OverhangSliceHD: "pkg:/images/Overhang_Slice_HD.png"
        OverhangSliceSD: "pkg:/images/Overhang_Slice_HD.png"
        OverhangLogoHD: "pkg:/images/channel_diner_logo.png"
        OverhangLogoSD: "pkg:/images/channel_diner_logo.png"
        OverhangOffsetSD_X: "25"
        OverhangOffsetSD_Y: "15"
        OverhangOffsetHD_X: "25"
        OverhangOffsetHD_Y: "15"
        BreadcrumbTextLeft: brandingGreen
        BreadcrumbTextRight: "#E1DFE0"
        BreadcrumbDelimiter: brandingGreen
        
        ListItemText: listItemText
        ListItemHighlightText: listItemHighlight
        ListScreenDescriptionText: listItemText
        ListItemHighlightHD: "pkg:/images/select_bkgnd.png"
        ListItemHighlightSD: "pkg:/images/select_bkgnd.png"
        CounterTextLeft: brandingGreen
        CounterSeparator: brandingGreen
        GridScreenBackgroundColor: backgroundColor
        GridScreenListNameColor: brandingGreen
        GridScreenDescriptionTitleColor: brandingGreen
        GridScreenLogoHD: "pkg://images/channel_diner_logo.png"
        GridScreenLogoSD: "pkg://images/channel_diner_logo.png"
        GridScreenOverhangHeightHD: "138"
        GridScreenOverhangHeightSD: "138"
        GridScreenOverhangSliceHD: "pkg:/images/Overhang_Slice_HD.png"
        GridScreenOverhangSliceSD: "pkg:/images/Overhang_Slice_HD.png"
        GridScreenLogoOffsetHD_X: "25"
        GridScreenLogoOffsetHD_Y: "15"
        GridScreenLogoOffsetSD_X: "25"
        GridScreenLogoOffsetSD_Y: "15"
    }
    app.SetTheme( theme )
End Function

Function InitFlixTheme() as void
    app = CreateObject("roAppManager")
    
    listItemHighlight           = "#CCCCCC"
    listItemText                = "#CCCCCC"
    brandingGreen               = "#FFFFFF"
    backgroundColor             = "#000000"
    theme = {
        BackgroundColor: backgroundColor
        OverhangSliceHD: "pkg:/images/Overhang_Slice_HD.png"
        OverhangSliceSD: "pkg:/images/Overhang_Slice_HD.png"
        OverhangLogoHD: "pkg:/images/DesiFlix.png"
        OverhangLogoSD: "pkg:/images/DesiFlix.png"
        OverhangOffsetSD_X: "25"
        OverhangOffsetSD_Y: "15"
        OverhangOffsetHD_X: "25"
        OverhangOffsetHD_Y: "15"
        BreadcrumbTextLeft: brandingGreen
        BreadcrumbTextRight: "#CCCCCC"
        BreadcrumbDelimiter: brandingGreen
        
        ListItemText: listItemText
        ListItemHighlightText: listItemHighlight
        ListScreenDescriptionText: listItemText
        ListItemHighlightHD: "pkg:/images/select_bkgnd.png"
        ListItemHighlightSD: "pkg:/images/select_bkgnd.png"
        CounterTextLeft: brandingGreen
        CounterSeparator: brandingGreen
        GridScreenBackgroundColor: backgroundColor
        GridScreenListNameColor: brandingGreen
        GridScreenDescriptionTitleColor: brandingGreen
        GridScreenLogoHD: "pkg://images/DesiFlix.png"
        GridScreenLogoSD: "pkg://images/DesiFlix.png"
        GridScreenOverhangHeightHD: "138"
        GridScreenOverhangHeightSD: "138"
        GridScreenOverhangSliceHD: "pkg:/images/Overhang_Slice_HD.png"
        GridScreenOverhangSliceSD: "pkg:/images/Overhang_Slice_HD.png"
        GridScreenLogoOffsetHD_X: "25"
        GridScreenLogoOffsetHD_Y: "15"
        GridScreenLogoOffsetSD_X: "25"
        GridScreenLogoOffsetSD_Y: "15"
    }
    app.SetTheme( theme )
End Function

Function InitContentList() as object
    contentList = [
        {
            Title: "Tamil",
            ID: "1",
            SDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDBackgroundImageUrl: "pkg:/images/breakfast_large.png",
            SDBackgroundImageUrl: "pkg:/images/breakfast_large.png",            
            ShortDescriptionLine1: "Tamil Videos",
            ShortDescriptionLine2: "Select from our Tamil Videos"
        },
        {
            Title: "Telugu",
            ID: "2",
            SDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDBackgroundImageUrl: "pkg:/images/lunch_large.png",
            SDBackgroundImageUrl: "pkg:/images/lunch_large.png",            
            ShortDescriptionLine1: "Telugu Videos",
            ShortDescriptionLine2: "Select from our Telugu Videos"            
        },
        {
            Title: "Hindi",
            ID: "3",
            SDSmallIconUrl: "pkg:/images/dinner_small.png",
            HDSmallIconUrl: "pkg:/images/dinner_small.png",
            HDBackgroundImageUrl: "pkg:/images/dinner_large.png",
            SDBackgroundImageUrl: "pkg:/images/dinner_large.png",            
            ShortDescriptionLine1: "Hindi Videos",
            ShortDescriptionLine2: "Select from our Hindi Videos"            
        },
        {
            Title: "Malayalam",
            ID: "4",
            SDSmallIconUrl: "pkg:/images/dessert_small.png",
            HDSmallIconUrl: "pkg:/images/dessert_small.png",
            HDBackgroundImageUrl: "pkg:/images/dessert_large.png",
            SDBackgroundImageUrl: "pkg:/images/dessert_large.png",            
            ShortDescriptionLine1: "Malayalam Videos",
            ShortDescriptionLine2: "Select from our Malayalam Videos"            
        }
        
    ]
    return contentList
End Function