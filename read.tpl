%rebase("template.tpl")
%import markdown

<div class="panel panel-default">
    <div class="panel-heading">
        <span class="panel-title">{{post["title"]}}</span>
        <div class="pull-right">Viewed {{post["views"]}} times.</div>
    </div>
    
    <div class="panel-body">
        <p>{{!markdown.markdown(post["content"])}}</p>
    </div>
</div>
