Function CreateBreakfastMenu() as integer
    screen = CreateObject("roPosterScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    
    screen.SetBreadcrumbText("Tamil", "HD Movies")

    screen.SetContentList(GetBreakfastMenuOptions())
    screen.SetFocusedListItem(4)
    screen.show()
    
    while (true)
        msg = wait(0, port)
        if type(msg) = "roPosterScreenEvent"
            if (msg.isScreenClosed())
                return -1
            else if (msg.isListItemSelected())
                ShowBreakfastItemDetails( msg.GetIndex() )
            endif
        endif
        
    end while
End Function

Function GetBreakfastMenuOptions() as object
    m.options = [
        {
            ShortDescriptionLine1: "A Freezer Classic"
            Price: "$0.99"
            Calories: "350"
            SDPosterURL: "pkg://images/breakfast_large.png"
            HDPosterURL: "pkg://images/breakfast_large.png"
        }
        {
            ShortDescriptionLine1: "Any Way You Like Them"
            Price: "$2.99"
            Calories: "200"
            SDPosterURL: "pkg://images/frying-eggs.jpg"
            HDPosterURL: "pkg://images/frying-eggs.jpg"        
        }
        {
            ShortDescriptionLine1: "Cinnamon Rolls"
            Price: "$1.99"
            Calories: "400"
            SDPosterURL: "pkg://images/cinnamon-rolls.jpg"
            HDPosterURL: "pkg://images/cinnamon-rolls.jpg"        
        }
        {
            ShortDescriptionLine1: "A Quick and Healthy Start"
            Price: "$2.99"
            Calories: "200"
            SDPosterURL: "pkg://images/cereal.jpg"
            HDPosterURL: "pkg://images/cereal.jpg"        
        }
        {
            ShortDescriptionLine1: "Fresh Fruit"
            Price: "$4.99"
            Calories: "150"
            SDPosterURL: "pkg://images/breakfast_fruit.jpg"
            HDPosterURL: "pkg://images/breakfast_fruit.jpg"        
        }        
        {
            ShortDescriptionLine1: "Breakfast Burrito"
            Price: "$3.99"
            Calories: "750"
            SDPosterURL: "pkg://images/breakfast-burrito.jpg"
            HDPosterURL: "pkg://images/breakfast-burrito.jpg"        
        }
        {
            ShortDescriptionLine1: "A Short Stack"
            Price: "$3.99"
            Calories: "800"
            SDPosterURL: "pkg://images/pancakes.jpg"
            HDPosterURL: "pkg://images/pancakes.jpg"        
        }        
        {
            ShortDescriptionLine1: "An Omlete... Sort Of..."
            Price: "$4.99"
            Calories: "800"
            SDPosterURL: "pkg://images/omelet.jpg"
            HDPosterURL: "pkg://images/omelet.jpg"        
        }
        {
            ShortDescriptionLine1: "That English Muffin Thing"
            Price: "$4.99"
            Calories: "1200"
            SDPosterURL: "pkg://images/mcmuff.jpg"
            HDPosterURL: "pkg://images/mcmuff.jpg"        
        }        
    ]
    return m.options
End Function

Function ShowBreakfastItemDetails(index as integer) as integer
    print "Selected Index: " + Stri(index)
    detailsScreen = CreateObject("roSpringboardScreen")
    port = CreateObject("roMessagePort")
    detailsScreen.SetMessagePort(port)
    detailsScreen.SetDescriptionStyle("generic")
    detailsScreen.SetBreadcrumbText("Tamil", m.options[index].ShortDescriptionLine1)
    detailsScreen.SetStaticRatingEnabled(false)
    
    details = {
        HDPosterUrl: m.options[index].HDPosterURL
        SDPosterUrl: m.options[index].SDPosterURL
        Description: m.options[index].ShortDescriptionLine1
        LabelAttrs: ["Price:", "Calories per Serving:"]
        LabelVals: [m.options[index].Price, m.options[index].Calories]
    }
    detailsScreen.SetContent(details)
    detailsScreen.AddButton(1, "Place Order")
    detailsScreen.AddButton(2, "Report to FDA")
    detailsScreen.show()
    
    while (true)
        msg = wait(0, port)
        if type(msg) = "roSpringboardScreenEvent"
            if (msg.isScreenClosed())
                return -1
            else if (msg.isButtonPressed())
                DetailsScreenButtonClicked( msg.GetIndex() )
            endif
        endif
    end while
End Function

Function DetailsScreenButtonClicked(index as integer) as void
    dialog = CreateObject("roOneLineDialog")
    if (index = 1)
        dialog.SetTitle("Placing Order")
    else if (index = 2)
        dialog.SetTitle("Reporting Food to FDA")
    endif
    dialog.ShowBusyAnimation()
    dialog.show()
    
    Sleep(4000)
End Function