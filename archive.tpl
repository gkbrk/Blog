%rebase("template.tpl")

<h2>Post Archive</h2>
<ul>
    %for post in posts:
        <li><a href="/read/{{post["url"]}}">{{post["title"]}}</a></li>
    %end
</ul>
