Function ShowHDList(languageName as String) as integer
    print "Selected language: " + languageName
    'CreateVideoListMenu(languageName, "HD")
     CreateServerVideoListMenu(languageName, "HD")
     
End Function

Function ShowBluRayList(languageName as String) as integer
    print "Selected language: " + languageName
    CreateServerVideoListMenu(languageName, "BLURAY")
   
End Function

Function ShowMovieList(languageName as String, videoType as String, organize as String) as integer
    print "Selected language: " + languageName+ " videoType : "+ videoType + " organize" + organize
    'CreateVideoListMenu(languageName, "HD")
     CreateServerVideoListMenu(languageName, videoType, organize)
     
End Function



Function CreateVideoListMenu(languageName as String, videoType as String) as integer

    print "Selected language: " + languageName + " videoType" + videoType
    screen = CreateObject("roGridScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    
    
    screen.SetBreadcrumbText(languageName, videoType)
    screen.SetupLists(2)
    videlLists = []
    'videlLists.Push(videoType)
    screen.SetListNames(videlLists)
    contentLists = loadVideoList(languageName, videoType)
    'contentLists.Push(loadVideoList(languageName, videoType))
    screen.SetContentList(0, contentLists)    
    videlLists.Push(contentLists)
    'screen.SetContentList(1, GetLunchMenuOptions_Tasty())
        
    screen.show()
    
    while (true)
        msg = wait(0, port)
        if type(msg) = "roGridScreenEvent"
            if (msg.isScreenClosed())
                return -1
            else if (msg.isListItemSelected())
                print msg
                selectedIndex = msg.GetIndex()
                selectedColumn = msg.GetData()
                 print "list item selected row= "; selectedIndex; " selection= "; selectedColumn
                 'print videlLists.Count()
                 contentList1 = videlLists[selectedIndex]
                 contentItem = contentList1[selectedColumn]
                 
                 print contentItem.Title 
                           'o = CreateObject("roAssociativeArray")
                 
                'selectedItem = 
                
                'selectedContetnList = 
                ShowVideoDetails(contentItem)
            endif
        endif
        
    end while
End Function


Function getListDetails(languageName as String, videoType as String,  organize as String) as object
    print "Selected language: " + languageName
    categorList =[]
    finalCategoryList = []
    
     listOptions = [
            { Name: "Recently Posted"
              Organize: "Activity"
              Filter:"RecentlyPosted"
              TotalPages:10
              PagesLoaded:0
              PageRequested:false
              AllPagesLoaded:false
              lastPageRequestedIndex:0
              totalPagesUpdated:false
            }
            { Name: "Recently Viewed"
              Organize: "Activity"
              Filter:"RecentlyViewed"
              TotalPages:10
              PagesLoaded:0
              PageRequested:false
              AllPagesLoaded:false
              lastPageRequestedIndex:0
              totalPagesUpdated:false
            }
            
            
       ]
    if (organize = "Activity") 
        categorList =loadCategoryDetailsList(languageName, videoType, "Cast", 45)
        for each activityFilter in listOptions
            finalCategoryList.Push(activityFilter)
        end for
        if categorList.Count() > 0
            for each activityFilter in categorList
                finalCategoryList.Push(activityFilter)
            end for
        end if 
    else 
        finalCategoryList =loadCategoryDetailsList(languageName, videoType, organize, 70)
    end if 
    
    
    
    
    
   
       
      if finalCategoryList.Count() =0 
         finalCategoryList = listOptions
       end if
       
     
       return finalCategoryList
   
End Function

Function CreateServerVideoListMenu(languageName as String, videoType as String,  organize as String) as integer

    print "Selected language: " + languageName + " videoType" + videoType + "  organize: " +  organize
    screen = CreateObject("roGridScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    videlLists = []
    'videlLists.Push(videoType)
    
    'contentLists = loadServerVideoList(languageName, videoType)
    contentLists =[]
    
    
    
    screen.SetBreadcrumbText(languageName, videoType+"-"+organize)
    categoryList = getListDetails(languageName,videoType, organize)
    screen.SetupLists(categoryList.Count())
   
   this ={
      screen : screen
      videlLists : videlLists
      categoryList : categoryList 
      reqCategoryQueue: []  
    }
   
    'contentLists.Push(loadVideoList(languageName, videoType))
    'screen.SetContentList(0, contentLists)    
    'videlLists.Push(contentLists)
    listNames = []
     rowCount = 0
    for each categoryListDetail in categoryList
            listName = categoryListDetail.Name
            listNames.Push(listName)
           ' screen.SetListName(rowCount,listName)
            rowCount = rowCount + 1
            
     end for
     
     screen.SetListNames(listNames)
      
    'screen.SetContentList(1, GetLunchMenuOptions_Tasty())
    screen.SetListOffset(0,0)
    screen.SetDisplayMode("photo-fit")
    screen.SetGridStyle("flat-16x9")
       
    screen.show()
    'contentLists = loadServerVideoList(languageName, videoType)
    
    
   ' videlLists.Push(contentLists)
    listIndex = 0
    'categoryDetails = getListDetails(languageName,videoType)
    numberOfListsToLoad = 2
    for each catListDetail in this.categoryList
             print "Starting iteration asunc event" + Str(listIndex).trim()
            listName = catListDetail.Name
            organize = catListDetail.Organize
            filter=catListDetail.Filter
           ' print "loading Category Name :" + listName + " Organize :" + organizee + " filter : "+ filter
            pageNumber = 1
            listContent = []
            
            
            'contentlists = getDummyContent() 
            contentlists = []
            videlLists.Push(contentlists)
            screen.SetContentList(listIndex, contentlists)
            print "Before loading asunc event" + Str(listIndex).trim()
            numberOfPages = 1
            if listindex < numberOfListsToLoad then
                loadAsyncServerVideoList(languageName, videoType,screen,this, catListDetail, listIndex, 1, false)
            else  
               ' screen.SetContentList(listIndex, getDummyContentList())
            end if
            'loadAsyncServerVideoList(languageName, videoType,screen, contentlists, videlLists, this,  catListDetail,  listIndex,  pageNumber,organize,filter) 
            
            print "loaded asunc event" + Str(listIndex).trim()
            listIndex = listIndex + 1
            
     end for
     screen.show()
    
    listenForEvents(screen,contentLists, videlLists, this, languageName, videoType)
    screen.show()
   
    
   print "Starting screen Message Loop" 
   
    
    
End Function

Function getDummyContent() as object
        buttons = [
            { Title: "Loading PlayList"
              ReleaseDate: "HD:5x2 SD:5x2"
              Description: "Flat-Movie (Netflix) style"
              HDPosterUrl:"http://upload.wikimedia.org/wikipedia/commons/4/43/Gold_star_on_blue.gif"
              SDPosterUrl:"http://upload.wikimedia.org/wikipedia/commons/4/43/Gold_star_on_blue.gif"
            }
        ]
       return buttons
End Function

Function listenForEvents(screen as Object, contentLists as object,videlLists as object, this as object , languageName as String, videoType as String) as object
        while (true)
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roGridScreenEvent"
            if (msg.isScreenClosed())
                return -1
            else if msg.isListItemFocused() then
               
                selectedColumn = msg.GetData()
                listIndex =  msg.GetIndex()
                'stop
                print "list Focussed item selected row= "; listIndex; " selection= "; selectedColumn               
                categoryListDetatil= this.categoryList[listIndex]
                
                listName = categoryListDetatil.Name
                organize = categoryListDetatil.Organize
                filter=categoryListDetatil.Filter
                totalPagesForCategory = categoryListDetatil.TotalPages
                pagesLoadedForCategory = categoryListDetatil.PagesLoaded
                allPagesLoadedForCategory = categoryListDetatil.AllPagesLoaded
                pageRequested = categoryListDetatil.PageRequested
                lastPageRequestedIndex = categoryListDetatil.lastPageRequestedIndex
                
                currentCategoryHalfIndex = (pagesLoadedForCategory / 2) * 6
                videlLists = this.videlLists
                contentLists = videlLists[listIndex]
                print "lastPageRequestedIndex= "; lastPageRequestedIndex; " currentCategoryHalfIndex= "; currentCategoryHalfIndex; " pageRequested= "; pageRequested; " allPagesLoadedForCategory";allPagesLoadedForCategory; " pagesLoadedForCategory";pagesLoadedForCategory
                if (selectedColumn > lastPageRequestedIndex and selectedColumn >= currentCategoryHalfIndex) or pagesLoadedForCategory = 0
                     if allPagesLoadedForCategory = false and pageRequested = false
                          print "List Focused Event to Load for category"+ listName 
                          loadAsyncServerVideoList(languageName, videoType,screen,this, categoryListDetatil, listIndex, 4,false)
                     end if
                end if
               
               
                    
            else if (msg.isListItemSelected())
                print msg
                
                selectedIndex = msg.GetIndex()
                selectedColumn = msg.GetData()
                 print "list item selected row= "; selectedIndex; " selection= "; selectedColumn
                 'print videlLists.Count()
                 
                 contentList1 = videlLists[selectedIndex]
                 
                 contentItem = contentList1[selectedColumn]
                 
                 print contentItem.Title 
                           'o = CreateObject("roAssociativeArray")
                 
                'selectedItem = 
                
                'selectedContetnList =
                
                ShowServerVideoDetails(contentItem, languageName)
            else if msg.isScreenClosed() then
                return ""
            
            endif
            
        endif
        
    end while
       
End Function


Function loadVideoList(languageName as String, videoType as String) as object
        videoContentList = InitMovieContentList()
        finalList = CreateObject("roArray")
        'print "Total List " + videoContentList.Count()
        For Each n In videoContentList
            Print n;
            contentList = n
            print "language = " + contentList["language"]
            if languageName = contentList["language"] then
                filteredist = contentList
                finalList = filteredist[videoType]
                print "Total finalList List " + Type(finalList) 
                
                
                Exit FOR
            end if 
            
        End For
        
        'print "Total Filtered List " + filteredist.Count()
       return finalList
       
End Function


Function loadServerVideoList(languageName as String, videoType as String) as object
        videoContentList = InitMovieContentList()
        
        request = CreateObject("roUrlTransfer")
        request.SetUrl("http://service-desiflix.rhcloud.com/VideoContentServie/videoservice/videoList?videoType=HD&language=tamil&organize=Cast&filter=vijay&pageNumber=1")
        html = request.GetToString()
        print " response : "+ html
        json = ParseJSON(html)
        finalList = [] 'CreateObject("roArray")'
        for each kind in json
            print kind
            
            finalList.Push(kind)
        end for
        
        
        
        'print "Total List " + videoContentList.Count()
        
        
        'print "Total Filtered List " + filteredist.Count()
       return finalList
       
End Function


Function loadCategoryDetailsList(languageName as String, videoType as String,organize as String, maxRecords as integer) as object
        categoryList = []
        
        request = CreateObject("roUrlTransfer")
        requestUrl = "http://service-desiflix.rhcloud.com/VideoContentServie/videoservice/playList?organize="+organize+"&language="+languageName+"&maxRecords="+Str(maxRecords).trim()
        request.SetUrl(requestUrl)
        
        
        html = request.GetToString()
        print " response : "+ html
        json = ParseJSON(html)
        print json
        for each kind in json
            print kind
            categoryDetail = { Name: "PlayList"
              Organize: organize
              Filter:""
              TotalPages:10
              PagesLoaded:0
              PageRequested:false
              AllPagesLoaded:false
              lastPageRequestedIndex:0
              totalPagesUpdated:false
            }
            categoryDetail.Name = kind
            categoryDetail.Filter = kind
          
            categoryList.Push(categoryDetail)
            
        end for
        
        print "Total CategoryList :"; categoryList.Count()
        
        'print "Total List " + videoContentList.Count()
        
        
        'print "Total Filtered List " + filteredist.Count()
       return categoryList
       
End Function


Function loadAsyncServerVideoList(languageName as String, videoType as String,screen as object,  this as object,  catListDetail as object, listIndex as integer, numberOfPages as integer, pageRequestedInCall as boolean) as object
        'videoContentList = InitMovieContentList()
        'stop
        request = CreateObject("roUrlTransfer")
        
        totalPagesToLoad = catListDetail.TotalPages
        pagesLoaded = catListDetail.PagesLoaded
        pageRequested = catListDetail.PageRequested
        allPagesLoaded = catListDetail.AllPagesLoaded
        
        organize = catListDetail.Organize
        filter = catListDetail.Filter
        totalPagesUpdated = true
        
        
        if pageRequested = false 
        catListDetail.PageRequested = true
        
               if pagesLoaded =0 
                    pageNumber = 1
                else
                    pageNumber = pagesLoaded + 1
                end if 
                
                finalPageNumberToLoad = pageNumber + numberOfPages
                
                videlLists = this.videlLists
                contentLists = videlLists[listIndex]
                
                
               
                 while (pageNumber <= finalPageNumberToLoad)
                        requestUrl="http://service-desiflix.rhcloud.com/VideoContentServie/videoservice/videoList?videoType="+videoType+"&language="+languageName+"&organize="+organize+"&filter="+filter+"&pageNumber="+Str(pageNumber).trim()
                
                        print requestUrl
                        request.SetUrl(requestUrl)
                        
                        port = CreateObject("roMessagePort")
                        request.SetMessagePort(port) 
                        continueWaiting = true
                        waitCount = 0
                        
                         if (request.AsyncGetToString())
                            createFurtherRequest = true
                            while (continueWaiting)
                                waitCount = waitCount + 1
                               ' print "waiting" + Str(waitCount)
                                msg = wait(5,   port)
                                event = type(msg)
                                if (type(msg) = "roUrlEvent")
                                    code = msg.GetResponseCode()
                                    'stop
                                   
                                    if (code = 200)
                                    'stop
                                        print "loading page"+Str(pageNumber).trim()
                                        playlist = CreateObject("roArray", 10, true)
                                        json = ParseJSON(msg.GetString())
                                        finalList = [] 'CreateObject("roArray")'
                                        
                                        'screen.SetContentList(listIndex, [])
                                        lastMovieDetail = {}
                                        for each kind in json
                                           ' print kind
                                            contentLists.push(kind)
                                            lastMovieDetail = kind
                                            
                                        end for
                                        
                                       
                                        if (contentLists.Count() > 0)
                                            screen.SetContentList(listIndex, contentLists)
                                            pagesLoaded = pagesLoaded + 1
                                            catListDetail.PagesLoaded = pagesLoaded
                                             if (catListDetail.totalPagesUpdated = false and lastMovieDetail.totalPagesInCategory > 0)
                                                catListDetail.TotalPages = lastMovieDetail.totalPagesInCategory
                                                catListDetail.totalPagesUpdated = true
                                             end if
                                        end if
                                        
                                        
                                       
                                       
                                       
                                        continueWaiting = false
                                        EXIT while
                                        
                                        
                                        'screen.show()
                                       
                                        
                                       
                                    endif
                                else if (event = invalid)
                                print "exiting"
                                    request.AsyncCancel()
                                endif
                                
                               
                            end while
                            
                        endif
                        pageNumber = pageNumber + 1
                 end while
                 
               
                print "loadingOnceMoe"; finalPageNumberToLoad; " pagesLoaded";
               
                 catListDetail.PagesLoaded = pagesLoaded
                 print "pagesLoaded"; pagesLoaded; "totalPagesToLoad";totalPagesToLoad
                 if pagesLoaded > totalPagesToLoad
                    catListDetail.AllPagesLoaded = true
                end if 
                catListDetail.PageRequested = false
                print "exiting loadAsynServerRquest"
                'listenForEvents(screen,contentLists, videlLists)
                'screen.show()
                'return invalid
                
                
                'print "Total List " + videoContentList.Count()
                
                
                'print "Total Filtered List " + filteredist.Count()
        end if
       
        
       
       
End Function

Function getDummyContentList() as Object
    contentList = [{
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"http://www.einthusan.com/images/thumbnail/small/movie/massu%20engira%20masilamani.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Surya movie Mass"
                    ShortDescriptionLine2:""
                    Description:"Massu Engira Masilamani Tamil Movie Online - Suriya, Nayantara, Pranitha, Premgi Amaren, Parthiban and Samuthirakani. Directed by Venkat Prabhu. Music by Yuvan ,Shankar Raja. 2015 Massu Engira Masilamani Tamil Movie Online."
                    Rating:"NR"
                    StarRating:"80"
                    Length:1280
                    Categories:["HD","ACTION"]
                    URL:"http://173.192.200.84/movies_tamil/movie_high/2669.mp4?st=-3MYHv9o2YUenSsYHrHjyQ&e=1436846964"
                    Title:"MASS"
                   
                   }
                 ]
                 
      return contentList      
End Function

Function InitMovieContentList() as object
    contentList = [
        {
            Title: "Tamil",
            ID: "1",
            SDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDBackgroundImageUrl: "pkg:/images/breakfast_large.png",
            SDBackgroundImageUrl: "pkg:/images/breakfast_large.png",
            Language: "Tamil",            
            ShortDescriptionLine1: "HD Videos",
            ShortDescriptionLine2: "Select from our HD Videos",
            HD: [
                {
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"http://www.einthusan.com/images/thumbnail/small/movie/massu%20engira%20masilamani.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Surya movie Mass"
                    ShortDescriptionLine2:""
                    Description:"Massu Engira Masilamani Tamil Movie Online - Suriya, Nayantara, Pranitha, Premgi Amaren, Parthiban and Samuthirakani. Directed by Venkat Prabhu. Music by Yuvan ,Shankar Raja. 2015 Massu Engira Masilamani Tamil Movie Online."
                    Rating:"NR"
                    StarRating:"80"
                    Length:1280
                    Categories:["HD","ACTION"]
                    URL:"http://173.192.200.84/movies_tamil/movie_high/2669.mp4?st=-3MYHv9o2YUenSsYHrHjyQ&e=1436846964"
                    Title:"MASS"
                   
                },
                 {
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"http://www.einthusan.com/images/thumbnail/small/movie/36%20vayadhinile.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Jothika's Vayathinilare"
                    ShortDescriptionLine2:""
                    Description:"Harvard psychologist Dan Gilbert says our beliefs about what will make us happy are often wrong -- a premise he supports with intriguing research, and explains in his accessible and unexpectedly funny book, Stumbling on Happiness."
                    Rating:"NR"
                    StarRating:"40"
                    Length:1280
                    Categories:["HD","FAMILY"]
                    URL:"http://173.192.200.84/movies_tamil/movie_high/2668.mp4?st=biYAnLy6SrMnXjRxF1QSjA&e=1436847038"
                    Title:"36 Vayathiniley"
                   
                },
                 {
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"http://www.einthusan.com/images/thumbnail/small/movie/36%20vayadhinile.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Jothika's Vayathinilare"
                    ShortDescriptionLine2:""
                    Description:"Harvard psychologist Dan Gilbert says our beliefs about what will make us happy are often wrong -- a premise he supports with intriguing research, and explains in his accessible and unexpectedly funny book, Stumbling on Happiness."
                    Rating:"NR"
                    StarRating:"40"
                    Length:1280
                    Categories:["HD","FAMILY"]
                    URL:"http://173.192.200.84/movies_tamil/movie_high/2668.mp4?st=biYAnLy6SrMnXjRxF1QSjA&e=1436847038"
                    Title:"Padayappa"
                   
                },
                 {
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"http://www.einthusan.com/images/thumbnail/small/movie/Nanban.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Vijay's Nanban"
                    ShortDescriptionLine2:""
                    Description:"Story About Friends"
                    Rating:"NR"
                    StarRating:"40"
                    Length:1280
                    Categories:["HD","FAMILY"]
                    'URL:"http://50.22.223.37/movies_tamil/movie_high/2669.mp4?st=3bvZ7IW28iBkwujMWcfdLw&e=1436962083"
                    URL:"http://50.97.49.74/movies_tamil/movie_high/614.mp4?st=Y9PG5e1ismo1UfD83dom4Q&e=1436962453"
                    Title:"Nanban"
                   
                }
        
            ],
            BLURAY: [
                {
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Surya movie Mass"
                    ShortDescriptionLine2:""
                    Description:"Massu Engira Masilamani Tamil Movie Online - Suriya, Nayantara, Pranitha, Premgi Amaren, Parthiban and Samuthirakani. Directed by Venkat Prabhu. Music by Yuvan ,Shankar Raja. 2015 Massu Engira Masilamani Tamil Movie Online."
                    Rating:"NR"
                    StarRating:"80"
                    Length:1280
                    Categories:["HD","ACTION"]
                    URL:"http://173.192.200.84/movies_tamil/movie_high/2669.mp4?st=-3MYHv9o2YUenSsYHrHjyQ&e=1436846964"
                    Title:"MASS BluRay"
                   
                },
                 {
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Jothika's Vayathinilare"
                    ShortDescriptionLine2:""
                    Description:"Harvard psychologist Dan Gilbert says our beliefs about what will make us happy are often wrong -- a premise he supports with intriguing research, and explains in his accessible and unexpectedly funny book, Stumbling on Happiness."
                    Rating:"NR"
                    StarRating:"40"
                    Length:1280
                    Categories:["HD","FAMILY"]
                    URL:"http://173.192.200.84/movies_tamil/movie_high/2668.mp4?st=biYAnLy6SrMnXjRxF1QSjA&e=1436847038"
                    Title:"36 Vayathiniley BluRay"
                   
                },
        
            ]
        },
       {
            Title: "Telugu",
            ID: "1",
            SDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDBackgroundImageUrl: "pkg:/images/breakfast_large.png",
            SDBackgroundImageUrl: "pkg:/images/breakfast_large.png",
            Language: "Tamil",            
            ShortDescriptionLine1: "HD Videos",
            ShortDescriptionLine2: "Select from our HD Videos",
            HD: [
                {
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Surya movie Mass"
                    ShortDescriptionLine2:""
                    Description:"Massu Engira Masilamani Tamil Movie Online - Suriya, Nayantara, Pranitha, Premgi Amaren, Parthiban and Samuthirakani. Directed by Venkat Prabhu. Music by Yuvan ,Shankar Raja. 2015 Massu Engira Masilamani Tamil Movie Online."
                    Rating:"NR"
                    StarRating:"80"
                    Length:1280
                    Categories:["HD","ACTION"]
                    URL:"http://173.192.200.84/movies_tamil/movie_high/2669.mp4?st=-3MYHv9o2YUenSsYHrHjyQ&e=1436846964"
                    Title:"MASS Telugu"
                   
                },
                 {
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Jothika's Vayathinilare"
                    ShortDescriptionLine2:""
                    Description:"Harvard psychologist Dan Gilbert says our beliefs about what will make us happy are often wrong -- a premise he supports with intriguing research, and explains in his accessible and unexpectedly funny book, Stumbling on Happiness."
                    Rating:"NR"
                    StarRating:"40"
                    Length:1280
                    Categories:["HD","FAMILY"]
                    URL:"http://173.192.200.84/movies_tamil/movie_high/2668.mp4?st=biYAnLy6SrMnXjRxF1QSjA&e=1436847038"
                    Title:"36 Vayathiniley Telugu"
                   
                },
        
            ],
            BLURAY: [
                {
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Surya movie Mass"
                    ShortDescriptionLine2:""
                    Description:"Massu Engira Masilamani Tamil Movie Online - Suriya, Nayantara, Pranitha, Premgi Amaren, Parthiban and Samuthirakani. Directed by Venkat Prabhu. Music by Yuvan ,Shankar Raja. 2015 Massu Engira Masilamani Tamil Movie Online."
                    Rating:"NR"
                    StarRating:"80"
                    Length:1280
                    Categories:["HD","ACTION"]
                    URL:"http://173.192.200.84/movies_tamil/movie_high/2669.mp4?st=-3MYHv9o2YUenSsYHrHjyQ&e=1436846964"
                    Title:"MASS BluRay Telugu"
                   
                },
                 {
                    ContentType:"episode"
                    SDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    HDPosterUrl:"file://pkg:/images/DanGilbert.jpg"
                    IsHD:TRUE
                    HDBranded:TRUE
                    ShortDescriptionLine1:"Jothika's Vayathinilare"
                    ShortDescriptionLine2:""
                    Description:"Harvard psychologist Dan Gilbert says our beliefs about what will make us happy are often wrong -- a premise he supports with intriguing research, and explains in his accessible and unexpectedly funny book, Stumbling on Happiness."
                    Rating:"NR"
                    StarRating:"40"
                    Length:1280
                    Categories:["HD","FAMILY"]
                    URL:"http://173.192.200.84/movies_tamil/movie_high/2668.mp4?st=biYAnLy6SrMnXjRxF1QSjA&e=1436847038"
                    Title:"36 Vayathiniley BluRay Telugu"
                   
                },
        
            ]
        },
        
    ]
    return contentList
End Function

