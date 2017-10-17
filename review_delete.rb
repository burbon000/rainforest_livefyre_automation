#tester starts at 
# https://lemonsarebetter.herokuapp.com/widget.php?network=rainforestqa.fyre.co&site=383920&articleId=ekrfjherf34823&appType=reviews&userId=user1_9080908090


test(id: 191991, title: "Review Post and Reply") do
  # You can use any of the following variables in your code:
  # - []
  
  # Random number to append to user_ids
  Capybara.default_selector = :css
  random_num = rand(10000000...99999999).to_s
  
  user1_id = "user1_" + random_num

  # App url for the two different users
  base_url1 = "https://lemonsarebetter.herokuapp.com/widget.php?network=rainforestqa.fyre.co"\
    "&site=383920&articleId=ekrfjherf34823&appType=reviews&userId=user1_#{random_num}"

  window = Capybara.current_session.driver.browser.manage.window
  #window.maximize
  Capybara.default_selector
  step id: 1,
      action: "Review app url loads",
      response: "Do you see Review app loaded with 'Average User Rating', 'Rating Breakdown',"\
        " 'Sign in' option and 'Write review' button?" do
    # *** START EDITING HERE ***
 
    # action
    visit base_url1

    # response
    expect(page).to have_content('Average User Rating', wait: 30)
    expect(page).to have_content('Rating Breakdown')
    expect(page).to have_content('Sign in')
    expect(page).to have_content('Write review')

    page.save_screenshot('screenshot_step_1.png')
    # *** STOP EDITING HERE ***
  end

  step id: 2,
      action: "Click on 'Sign in' option",
      response: "Do you see next to avatar 'user1_{{random.number}}'?" do
    # *** START EDITING HERE ***
    
    # action
    page.find(:css, "a[role='button']", :text => 'Sign in').click
    
    # reponse
    expect(page).to have_selector(:css, "a[role='button']", :text => user1_id)

    page.save_screenshot('screenshot_step_2.png')
    # *** STOP EDITING HERE ***
  end

  step id: 3,
      action: "Click on 'Write review' button",
      response: "Do you see Review comment widget with 5 empty stars, 'Title...'' section,"\
        " empty comment section, and 'Post review' button?" do
   
    # *** START EDITING HERE ***

    # action
    page.find(:css, 'button', :text => 'Write review').click

    # response
    expect(page).to have_no_selector(:css, 'button', :text => 'Write review', wait: 10)
    within(:css, ".fyre-editor.fyre-reviews-editor.fyre-editor-small") do  
      expect(page).to have_content("Post review")
      expect(page).to have_css('.goog-ratings')
      expect(find(:css, '.goog-ratings')['aria-valuenow']).to eql(nil)
      expect(page.find(:css, '.fyre-editor-title')['placeholder']).to eql("Title...")
      within_frame(find(:css, '[aria-label=editor]')) do
        expect(page.find(:css, 'p')['text']).to eql(nil)
      end
    end

    page.save_screenshot('screenshot_step_3.png')
    # *** STOP EDITING HERE ***
  end

  step id: 4,
      action: "Enter text in 'Title...', text in comment section and choose star rating from top right side,"\
        " then click 'Post review' button",
      response: "Do you see your review posted on the stream below with title, comment text, star options "\
        "selected in yellow and username?" do
    
    # *** START EDITING HERE ***
    title = "automation" + random_num
    review = "User1 Review " + random_num
    star_rating = rand(0...9)
    rating_perc = star_rating*10 + 10
    rating_style = "width: #{rating_perc}%"

    # action
    within(:css, ".fyre-editor.fyre-reviews-editor.fyre-editor-small") do
      page.find("input[class='fyre-editor-title']").set(title)
      within_frame(find(:css, '[aria-label=editor]')) do
        page.find(:css, '.editable.fyre-editor-field>p').click
        page.find(:css, '.editable.fyre-editor-field>p').native.send_keys(review)
      end
      all(:css, "span[class*='ratings-star']")[star_rating].click
      page.find("div[role='button']", :text => 'Post review').click
    end

    # response
    within(:css, "article[data-author-id^='#{user1_id}']", wait: 20) do
      expect(page).to have_selector(:css, ".fyre-reviews-rated>label[style^='#{rating_style}']") 
      expect(page).not_to have_css('iframe', wait: 5)
      expect(page).to have_content(user1_id)
      expect(page).to have_content(title)
      expect(page).to have_content(review)
    end

    page.save_screenshot('screenshot_step_4.png')
    # *** STOP EDITING HERE ***
  end

  step id: 5,
      action: "On your posted comment click '...More' option",
      response: "Do you see a drop down option with 'Edit' and 'Delete' options ?" do
   
    # *** START EDITING HERE ***

    # action
    within(:css, "article[data-author-id^='#{user1_id}']") do
      page.find("a", :text => 'More').click
    end

    # response
    within(:css, '.fyre-actions-menu') do
      expect(page).to have_selector(:css, "li", :text => 'Edit')
      expect(page).to have_selector(:css, "li", :text => 'Delete')
    end
    
    page.save_screenshot('screenshot_step_5.png')
    # *** STOP EDITING HERE ***
  end

  step id: 6,
    action: "Click on 'Delete' option from the drop down window",
    response: "Do you see your posted comment deleted from review stream ?" do
      
    # *** START EDITING HERE ***
    
    # action
    within(:css, '.fyre-actions-menu') do
      page.find(:css, "li", :text => 'Delete').click
    end
    visit base_url1

    # response
    expect(page).to have_no_selector(:css, "article[data-author-id^='#{user1_id}']", :visible => true, wait: 40)

    page.save_screenshot('screenshot_step_6.png')
    # *** STOP EDITING HERE ***

  end

end
