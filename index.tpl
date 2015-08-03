%rebase("template.tpl")
%import markdown

%for post in posts:
    <div class="panel panel-default">
        <div class="panel-heading">
            <a class="panel-title" href="/read/{{post["url"]}}">{{post["title"]}}</a>
            <div class="pull-right">Viewed {{post["views"]}} times.</div>
        </div>
        
        <div class="panel-body">
            <p>{{!markdown.markdown(post["content"][:500])}}</p>
        </div>
        
        <div class="panel-footer"><a href="/read/{{post["url"]}}">Read more</a></div>
    </div>
%end
