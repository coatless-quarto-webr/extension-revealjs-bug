local injectionComplete = false

function injectIntoHeader()
  
  -- If we've included the initialization, then bail.
  if injectionComplete then
    return
  end
  
  -- Otherwise, let's include the initialization script _once_
  injectionComplete = true

  -- Sample initialization
  local example_text = [[
    <script>
    // the hello world program
    document.write('Hello, World!');
    </script>
  ]]

  -- Insert the web initialization
  -- https://quarto.org/docs/extensions/lua-api.html#includes
  quarto.doc.include_text("in-header", example_text)
end

function detectCodeCell(el)
      
  -- Let's see what's going on here:
  -- quarto.log.output(el)
  
  -- Should display the following elements:
  -- https://pandoc.org/lua-filters.html#type-codeblock
  
  -- Verify the element has attributes and the document type is HTML
  if el.attr and quarto.doc.is_format("html") then

    if el.attr.classes:includes("{somecode-r}") then
      
      -- Make sure we've initialized the code block
      injectIntoHeader()

      -- Return the modified HTML template as a raw cell
      return pandoc.RawInline('html', 'Replaced cell')
    end
  end
  -- Allow for a pass through in other languages
  return el
end

return {
  {
    CodeBlock = detectCodeCell
  }
}

