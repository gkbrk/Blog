%rebase("template.tpl")
%import bottle

<script src="/static/js/showdown.js"></script>

<form class="form-horizontal" action="{{"/edit/{}".format(postid) if postid != -1 else "/edit"}}" method="post">
    <div class="input-group">
        <div class="input-group-addon">Post title</div>
        <input type="text" class="form-control" name="title" placeholder="Post title" value="{{post["title"] if post else bottle.request.forms.get("title", "")}}">
    </div>
    <br>
    <div class="input-group">
        <div class="input-group-addon">Post URL</div>
        <input type="text" class="form-control" name="url" placeholder="Post URL" value="{{post["url"] if post else ""}}">
    </div>
    <br>
    <div class="row">
        <div class="col-md-6">
            <textarea class="form-control" style="height: 100px;" id="postContent" name="content">{{post["content"] if post else ""}}</textarea>
        </div>
        <div class="col-md-6" id="rendered">
        </div>
    </div>
    <br>
    <button type="submit" class="btn btn-default form-control">Save post</button>
</form>

<script>
    var postContent = document.getElementById("postContent");
    var markdown = new Showdown.converter();
    var renderedContent = document.getElementById("rendered");
    
    var renderContent = function (){
        postContent.style.height = "1px";
        postContent.style.height = postContent.scrollHeight+10 + "px";
        renderedContent.innerHTML = markdown.makeHtml(postContent.value);
    };
    
    renderContent();
    postContent.addEventListener("input", renderContent);
</script>
