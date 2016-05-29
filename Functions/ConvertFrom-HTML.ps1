function ConvertFrom-HTML {
    #converts html to text to display in console
    param([System.String] $html)
    
    # remove line breaks, replace with spaces
    $html = $html -replace "(`r|`n|`t)", " "
    # write-verbose "removed line breaks: `n`n$html`n"
    
    # remove invisible content
    @('head', 'style', 'script', 'object', 'embed', 'applet', 'noframes', 'noscript', 'noembed') | % {
    $html = $html -replace "<$_[^>]*?>.*?</$_>", ""
    }
    # write-verbose "removed invisible blocks: `n`n$html`n"
    
    # Condense extra whitespace
    $html = $html -replace "( )+", " "
    # write-verbose "condensed whitespace: `n`n$html`n"
    
    # Add line breaks
    @('href','div','p','blockquote','h[1-9]') | % { $html = $html -replace "</?$_[^>]*?>.*?</$_>", ("`n" + '$0' )} 
    # Add line breaks for self-closing tags
    @('href','div','p','blockquote','h[1-9]','br') | % { $html = $html -replace "<$_[^>]*?/>", ('$0' + "`n")} 
    # write-verbose "added line breaks: `n`n$html`n"
    
    #strip tags 
    $html = $html -replace "<[^>]*?>", ""
    # write-verbose "removed tags: `n`n$html`n"
      
    # replace common entities
    @( 
    @("&amp;bull;", " * "),
    @("&amp;lsaquo;", "<"),
    @("&amp;rsaquo;", ">"),
    @("&amp;(rsquo|lsquo);", "'"),
    @("&amp;(quot|ldquo|rdquo);", '"'),
    @("&amp;trade;", "(tm)"),
    @("&amp;frasl;", "/"),
    @("&amp;(quot|#34|#034|#x22);", '"'),
    @('&amp;(amp|#38|#038|#x26);', "&amp;"),
    @("&amp;(lt|#60|#060|#x3c);", "<"),
    @("&amp;(gt|#62|#062|#x3e);", ">"),
    @('&amp;(copy|#169);', "(c)"),
    @("&amp;(reg|#174);", " "),
    @("&amp;nbsp;", " "),
    @("&nbsp;", " "),
    @("&#8217;", "'"),
    @("&#8230;", "..."),
    @("&#8220;", "`""),
    @("&#8221;", "`""),
    @("&bull;", " * "),
    @("&lsaquo;", "<"),
    @("&rsaquo;", ">"),
    @("&(rsquo|lsquo);", "'"),
    @("&(quot|ldquo|rdquo);", '"'),
    @("&trade;", "(tm)"),
    @("&frasl;", "/"),
    @("&(quot|#34|#034|#x22);", '"'),
    @('&(amp|#38|#038|#x26);', "&"),
    @("&(lt|#60|#060|#x3c);", "<"),
    @("&(gt|#62|#062|#x3e);", ">"),
    @('&(copy|#169);', "(c)"),
    @("&(reg|#174);", " "),
    @("  ", " "),
    @("`n`n", "`n"),
    @("&amp;(.{2,6});", "")
    ) | % { $html = $html -replace $_[0], $_[1] }

    @( 
    @("`n", "`n`n")
    ) | % { $html = $html -replace $_[0], $_[1] }
    # write-verbose "replaced entities: `n`n$html`n"
    
    return $html
    
}  