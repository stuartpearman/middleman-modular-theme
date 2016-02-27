def page_title
  title = site_title
  if current_article && current_article.title
    title = site_title + " | " +  current_article.title
  end

  title
end

def page_description
  description = site_description

  if current_article && current_article.summary(100)
    description = current_article.summary(100)
  end

  description
end

def page_keywords
  keywords = [] # Set site keywords here

  if current_article && current_article.tags
    keywords.concat(current_article.data.tags)
  end

  keywords.uniq.join(", ")
end

def page_or_default(variable)
  if 'variable' === 'title'
    return @title
  end
  return current_page.data[variable] || data.site[variable]
end

def environmentVariable(variable)
if build? == false
  return data.site[variable+'-dev']
end
data.site[variable+'-prod']
end

def full_site_url(path)
 (data.site.deployroot+path).gsub(/([^:])\/\//, '\1/')
end
def is_home?
 current_page.url == "/"
end
def is_parent_menu(menuItem)
 dataCount = 0
 if menuItem.key?("url")
  dataCount = dataCount + 1
end
 if menuItem.key?("extrahtml")
  dataCount = dataCount + 1
end
 return menuItem.count > dataCount
end

def landing_page_link

link = "unset-check-config.rb"
link = current_page.data["landing_page_link"] || data.site.defaults["landing_page_link"]
if link.end_with? current_page.url
  link = data.site.defaults["buy_now"]
end
return link
end

def getData(filePath, symbol)
fm = extensions[:frontmatter]
localFilePath = filePath.gsub(config.source + "/", "")
parsedData  = fm.data(localFilePath)
fmData = parsedData[0]
fmData[symbol]
end

#I'm insure how to do two blocks in the other block so this :(
def getLabelTag(controlText, controlId)
return "<label for='#{controlId}'>#{controlText}</label>"
#aaa = label_tag controlId do
#  controlText
#end
#return aaa
end

def genericForm (controlText, required, classname, helperText, insertText = "")

controlId = controlText.gsub(/\W/,'').downcase
lt = getLabelTag(controlText, controlId)
tft =  text_field_tag controlText, :required => required, :placeholder => controlText, :class => "form-control", :id => controlId
requiredString = ""
if required
requiredString = "required=\"required\" aria-required=\"true\" data-rule-required=\"true\""
end
placeholderString = controlText
if helperText != ""
placeholderString = helperText
end

tft = "<input type=\"text\" #{insertText} name=\"#{controlText}\" placeholder=\"#{placeholderString}\" class=\"form-control\" id=\"#{controlId}\" #{requiredString}>"
return content_tag(:div, lt+tft, class: "form-group " + classname)
end

def textForm(controlText, required = false, classname="col-md-6", helperText ="", insertText = "")
return  genericForm(controlText, required, classname, helperText, insertText)
end

def dateForm(controlText, required = false, classname="col-md-6", helperText ="")
return  genericForm(controlText, required, classname, helperText, "data-rule-date=\"true\"" )
end

def zipForm(controlText, required = false, classname="col-md-6", helperText ="")
return  genericForm(controlText, required, classname, helperText, "data-rule-zipcodeUS=\"true\"" )
end

def numberForm(controlText, required = false, classname="col-md-6")
controlId = controlText.gsub(/\W/,'').downcase
lt = getLabelTag(controlText.dup, controlId.dup)
tft =  number_field_tag controlText, :required => required, :placeholder => controlText, :class => "form-control", :id => controlId
return content_tag(:div, lt+tft, class: "form-group " + classname)
end

def selectForm(controlText, selects, required = false, classname="col-md-6", insertText = "")
 controlId = controlText.gsub(/\W/,'').downcase
 lt = getLabelTag(controlText.dup, controlId.dup)
 tft =  select_tag controlText, :options => selects,:required => required, :placeholder => controlText, :class => "form-control", :id => controlId
 #the next two lines are because I don't know how to insert HTML attributes with the padrino call.
 swap = "id=\"#{controlId}\""
 tft.sub! swap, "#{swap} #{insertText}"
 return content_tag(:div, lt+tft, class: "form-group " + classname)
end

def buildProductUrl(productName)
  "/bookstore/#{productName.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')}/"
end
