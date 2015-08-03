<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>GKBRK.com | Blog</title>
        <link rel="stylesheet" href="/static/bootstrap.min.css">
        <style>
            .nav.navbar-nav li a:hover{
                background-color: lightgray;
            }
            
            *{
                transition: background-color 0.5s ease;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-default">
            <div class="container">
                <div class="navbar-header">
                    <a class="navbar-brand" href="/">GKBRK.com Blog</a>
                </div>
                <ul class="nav navbar-nav">
                    <li><a href="/archive">Archive</a></li>
                </ul>
            </div>
        </nav>
        <div class="container">
            {{!base}}
            <footer><hr><span>&copy; 2015 Gökberk Yaltıraklı</span><span class="pull-right"><a href="/admin">Admin panel</a></span></footer>
        </div>
    </body>
</html>
