' ********************************************************************
' **  Sample PlayVideo App
' **  Copyright (c) 2009 Roku Inc. All Rights Reserved.
' ********************************************************************


Function ShowVideoDetails(videoItem as Object) as integer
    
    print "Selected language: " + videoItem.Title
    print "Selected language: " + videoItem.URL
      videoItem.VideoURL = videoItem.URL
     showSpringboardScreen(videoItem)  
    
    'exit the app gently so that the screen doesn't flash to black
    'screenFacade.showMessage("")
    sleep(25)
    
   
End Function


Function ShowServerVideoDetails(videoItem as Object, languageName as String) as integer
    
    print "Selected language: " + videoItem.Title
    print "Selected url: " + videoItem.URL
    print "Selected VideoId: " + videoItem.videoId
     
        showSpringboardScreen(videoItem, languageName)  
    
    'exit the app gently so that the screen doesn't flash to black
    'screenFacade.showMessage("")
    sleep(25)
    
   
End Function



'*************************************************************
'** Set the configurable theme attributes for the application
'** 
'** Configure the custom overhang and Logo attributes
'*************************************************************


'*************************************************************
'** showSpringboardScreen()
'*************************************************************

Function showSpringboardScreen(item as object, languageName as String) As Boolean
    port = CreateObject("roMessagePort")
    screen = CreateObject("roSpringboardScreen")

    print "showSpringboardScreen"
    
    screen.SetMessagePort(port)
    screen.AllowUpdates(false)
    if item <> invalid and type(item) = "roAssociativeArray"
        screen.SetContent(item)
    endif

    screen.SetDescriptionStyle("generic") 'audio, movie, video, generic
                                        ' generic+episode=4x3,
    screen.ClearButtons()
    screen.AddButton(1,"Loading video.....")
    screen.AddButton(2,"Go Back")
    screen.SetStaticRatingEnabled(false)
    screen.AllowUpdates(false)
    screen.Show()

    videoRequestUrl="http://service-desiflix.rhcloud.com/VideoContentServie/videoservice/videoURL?videoId=" +item.videoId +"&language="+languageName
    request = CreateObject("roUrlTransfer")
    request.SetUrl(videoRequestUrl)
    html = request.GetToString()
    print " response : "+ html
    json = ParseJSON(html)        
    finalList = [] 'CreateObject("roArray")'
    item.VideoURL = json.videoUrl 
    
    screen.ClearButtons()
    screen.AddButton(1,"Play")
    screen.AddButton(2,"Go Back")
    screen.SetStaticRatingEnabled(false)
    screen.AllowUpdates(true)
    screen.Show()
    downKey=3
    selectKey=6
    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roSpringboardScreenEvent"
            if msg.isScreenClosed()
                print "Screen closed"
                exit while                
            else if msg.isButtonPressed()
                    print "Button pressed: "; msg.GetIndex(); " " msg.GetData()
                    if msg.GetIndex() = 1
                         displayVideo(item)
                    else if msg.GetIndex() = 2
                         return true
                    endif
            else
                print "Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
            endif
        else 
            print "wrong type.... type=";msg.GetType(); " msg: "; msg.GetMessage()
        endif
    end while


    return true
End Function


'*************************************************************
'** displayVideo()
'*************************************************************

Function displayVideo(args As Dynamic)
    print "Displaying video: " + args.Title
    print "Displaying video: " + args.VideoURL
    p = CreateObject("roMessagePort")
    video = CreateObject("roVideoScreen")
    video.setMessagePort(p)

    'bitrates  = [0]          ' 0 = no dots, adaptive bitrate
    'bitrates  = [348]    ' <500 Kbps = 1 dot
    'bitrates  = [664]    ' <800 Kbps = 2 dots
    'bitrates  = [996]    ' <1.1Mbps  = 3 dots
    'bitrates  = [2048]    ' >=1.1Mbps = 4 dots
    bitrates  = [0]    

    'Swap the commented values below to play different video clips...
    urls = ["http://video.ted.com/talks/podcast/CraigVenter_2008_480.mp4"]
    qualities = ["HD"]
    StreamFormat = "mp4"
    title = "Craig Venter Synthetic Life"
    'srt = "file://pkg:/source/craigventer.srt"
    srt = ""

    'urls = ["http://video.ted.com/talks/podcast/DanGilbert_2004_480.mp4"]
    'qualities = ["HD"]
    'StreamFormat = "mp4"
    'title = "Dan Gilbert asks, Why are we happy?"

    ' Apple's HLS test stream
    'urls = ["http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"]
    'qualities = ["SD"]
    'streamformat = "hls"
    'title = "Apple BipBop Test Stream"

    ' Big Buck Bunny test stream from Wowza
    'urls = ["http://ec2-174-129-153-104.compute-1.amazonaws.com:1935/vod/smil:BigBuckBunny.smil/playlist.m3u8"]
    'qualities = ["SD"]
    'streamformat = "hls"
    'title = "Big Buck Bunny"
    
    if type(args) = "roAssociativeArray"
        if args.VideoURL <> "" then
            urls[0] = args.VideoURL
        end if
        if type(args.StreamFormat) = "roString" and args.StreamFormat <> "" then
            StreamFormat = args.StreamFormat
        end if
        if type(args.Title) = "roString" and args.Title <> "" then
            title = args.Title
        else 
            title = ""
        end if
        if type(args.srt) = "roString" and args.srt <> "" then
            srt = args.StreamFormat
        else 
            srt = ""
        end if
    end if
    
    
    videoclip = CreateObject("roAssociativeArray")
    videoclip.StreamBitrates = bitrates
    videoclip.StreamUrls = urls
    videoclip.StreamQualities = qualities
    videoclip.StreamFormat = StreamFormat
    videoclip.Title = title
    print "srt = ";srt
    if srt <> invalid and srt <> "" then
        videoclip.SubtitleUrl = srt
    end if
    
    video.SetContent(videoclip)
    video.show()

    lastSavedPos   = 0
    statusInterval = 10 'position must change by more than this number of seconds before saving

    while true
        msg = wait(0, video.GetMessagePort())
        if type(msg) = "roVideoScreenEvent"
            if msg.isScreenClosed() then 'ScreenClosed event
                print "Closing video screen"
                exit while
            else if msg.isPlaybackPosition() then
                nowpos = msg.GetIndex()
                if nowpos > 10000
                    
                end if
                if nowpos > 0
                    if abs(nowpos - lastSavedPos) > statusInterval
                        lastSavedPos = nowpos
                    end if
                end if
            else if msg.isRequestFailed()
                print "play failed: "; msg.GetMessage()
            else
                print "Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
            endif
        end if
    end while
End Function

