Function Main() as void
    this = {
        listScreen: CreateObject("roListScreen")
        listScreenPort: CreateObject("roMessagePort")
        topics: get_playlist()
        FormatBreadcrumb: format_breadcrumb
        topic_count: 0
    }
    this.listScreen.SetMessagePort(this.listScreenPort)
    this.listScreen.SetTitle("Web Services Sample Channel")
    this.listScreen.SetHeader("Topics")
    this.topic_count = Stri(this.topics.Count())
    this.listScreen.SetBreadcrumbText(Stri(this.topics.Count()), "")
    this.listScreen.SetContent(this.topics)
    this.listScreen.Show()
    while (true)
        msg = wait(1000, this.listScreenPort)
        if (type(msg) = "roListScreenEvent")
            if (msg.isListItemSelected())
                index = msg.GetIndex()
                ShowVideoScreen(this.topics[index].Title, get_topic_videos(this.topics[index].ID))
            else if (msg.isListItemFocused())
                this.listScreen.SetBreadcrumbText(this.FormatBreadcrumb(msg.GetIndex()), "")                
            endif
        endif
        if (msg = invalid)
            print "No message received, do some other work before checking for events again"
        endif
    end while
End Function

Function format_breadcrumb(id as integer) as String
    return "Topic " + Stri(id) + " of " + m.topic_count
End Function

Function get_playlist() as object
    request = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    request.SetMessagePort(port)
    request.SetUrl("http://www.khanacademy.org/api/v1/playlists")
    
    if (request.AsyncGetToString())
        while (true)
            msg = wait(0, port)
            if (type(msg) = "roUrlEvent")
                code = msg.GetResponseCode()
                if (code = 200)
                    playlist = CreateObject("roArray", 10, true)
                    json = ParseJSON(msg.GetString())
                    for each kind in json
                        topic = {
                            ID: kind.id
                            Title: kind.standalone_title
                        }
                        playlist.push(topic)
                    end for
                    return playlist
                endif
            else if (event = invalid)
                request.AsyncCancel()
            endif
        end while
    endif
    return invalid
End Function

Function get_topic_videos(id as String) as object
    request = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    request.SetMessagePort(port)
    request.SetUrl("http://www.khanacademy.org/api/v1/topic/" + id + "/videos")
    
    if (request.AsyncGetToString())
        while (true)
            msg = wait(1000, port)
            if (type(msg) = "roUrlEvent")
                code = msg.GetResponseCode()
                if (code = 200)
                    videos = CreateObject("roArray", 10, true)
                    json = ParseJSON(msg.GetString())
                    for each kind in json
                        video = {
                            Title: kind.title
                            ShortDescriptionLine1: kind.description
                            Description: kind.description
                            Views: kind.views
                        }
                        if (kind.download_urls <> invalid)
                            video.SDPosterURL = kind.download_urls.png
                            video.HDPosterURL = kind.download_urls.png
                            video.Url = kind.download_urls.m3u8
                        endif
                        
                        videos.push(video)
                    end for
                    return videos
                endif
            endif
            if (msg = invalid)
                request.AsyncCancel()
            endif            
        end while
    endif
    return invalid
End Function

