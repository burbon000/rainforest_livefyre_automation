#tester starts at 
# https://lemonsarebetter.herokuapp.com/widget.php?network=rainforestqa.fyre.co&site=383920&articleId=ekrfjherf34823&appType=reviews&userId=user1_9080908090


test(id: 42126, title: "Review Flag") do
  # You can use any of the following variables in your code:
  # - []
  Capybara.save_path = "review_flag/"

  # used to run Saucelabs with version 45 of Firefox. Version 50 was causing problems with some functionality
  Capybara.register_driver :sauce do |app|
    @desired_cap = {
      'platform': "Windows 7",
      'browserName': "firefox",
      'version': "45",
      'screenResolution': "1440x900",
      'name': "livefyre_review_flag",
    }
    Capybara::Selenium::Driver.new(app,
      :browser => :remote,
      :url => 'http://@ondemand.saucelabs.com:80/wd/hub',
      :desired_capabilities => @desired_cap
    )
  end
  # chrome testing
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  # browser name to be used to determine which behavior to emulate
  browser_name = Capybara.current_session.driver.browser.capabilities.browser_name
  # Random number to append to user_ids
  random_num = rand(10000000...99999999).to_s
  
  user1_id = "user1_" + random_num
  user2_id = "user2_" + random_num

  # App url for the two different users
  base_url1 = "https://lemonsarebetter.herokuapp.com/widget.php?network=rainforestqa.fyre.co"\
    "&site=383920&articleId=ekrfjherf34823&appType=reviews&userId=user1_#{random_num}"
  base_url2 = "https://lemonsarebetter.herokuapp.com/widget.php?network=rainforestqa.fyre.co"\
    "&site=383920&articleId=ekrfjherf34823&appType=reviews&userId=user2_#{random_num}"

  #window = Capybara.current_session.driver.browser.manage.window
  #window.maximize
  
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

    #page.save_screenshot('screenshot_step_1.png')
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
    
    #page.save_screenshot('screenshot_step_2.png')
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
    within(:css, '.fyre-editor.fyre-reviews-editor.fyre-editor-small') do  
      expect(page).to have_content("Post review")
      expect(page).to have_css('.goog-ratings')
      expect(find(:css, '.goog-ratings')['aria-valuenow']).to eql(nil)
      expect(page.find(:css, '.fyre-editor-title')['placeholder']).to eql("Title...")
      case browser_name
      when 'firefox'
        within_frame(find(:css, '[aria-label=editor]')) do
          expect(page.find(:css, 'p')['text']).to eql(nil)
        end
      when 'chrome'
        expect(page.find(:css, '.fyre-editor-editable.editable.fyre-editor-field')['text']).to eql(nil)
      end
    end

    #page.save_screenshot('screenshot_step_3.png')
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
      page.find(:css, "input[class='fyre-editor-title']").set(title)
      case browser_name
      when 'firefox'
        within_frame(find(:css, '[aria-label=editor]')) do
          page.find(:css, '.editable.fyre-editor-field>p').click
          for x in 0...review.length do
            page.find(:css, '.editable.fyre-editor-field>p').native.send_keys(review[x])
          end
        end
      when 'chrome'
        page.find(:css, '.fyre-editor-editable.editable.fyre-editor-field').click
        for x in 0...review.length do
          page.find(:css, '.fyre-editor-editable.editable.fyre-editor-field').send_keys(review[x])
        end
      end
      all(:css, "span[class*='ratings-star']")[star_rating].click
      page.find(:css, "div[role='button']", :text => 'Post review', :match => :first).click
    end

    # response
    within(:css, "article[data-author-id^='#{user1_id}']", wait: 20) do
      expect(page).to have_selector(:css, ".fyre-reviews-rated>label[style^='#{rating_style}']")  
      expect(page).to have_content(user1_id)
      expect(page).to have_content(title)
      expect(page).to have_content(review) 
    end
    expect(page).to have_no_selector(:css, 'span.fyre-editor-spinner', wait: 10)   

    #page.save_screenshot('screenshot_step_4.png')
    # *** STOP EDITING HERE ***
  end

  step id: 5,
      action: "Go to user avatar and click on 'Sign out' option",
      response: "Do you see 'Sign in' option ?" do
   
    # *** START EDITING HERE ***
 

    # Currently the new post is not visible in a sorted list for up to 10 minutes. The
    # => work around is to either wait 10 minutes or not use the sort by newest.
    #for i in 1..10 do
    #  page.find(:css, "a[role='button']", :text => user1_id).click     
    #  sleep(60)
    #end

    # action
    within(:css, '.fyre-login-bar') do
      page.find(:css, ".fyre-user-profile-link.fyre-user-loggedin").hover
      page.find(:css, "a[title='Sign out']").click
    end
    
    # response
    expect(page).to have_content('Sign in')

    #page.save_screenshot('screenshot_step_5.png')
    # *** STOP EDITING HERE ***
  end

  step id: 6,
    action: "Review app url loads",
    response: "Do you see Review app loaded with 'Average User Rating', 'Rating Breakdown', "\
      "'Sign in' option and 'Write review' button?" do
      
    # *** START EDITING HERE ***
    
    # action
    visit base_url2

    # response
    expect(page).to have_content('Average User Rating', wait: 15)
    expect(page).to have_content('Rating Breakdown')
    expect(page).to have_content('Sign in')
    expect(page).to have_content('Write review')

    #page.save_screenshot('screenshot_step_6.png')
    # *** STOP EDITING HERE ***

  end
  
  
 step id: 7,
      action: "Click on 'Sign in' option",
      response: "Do you see next to avatar 'user2_{{random.number}}'?" do

    # *** START EDITING HERE ***

    # action
    within(:css, '.fyre-login-bar') do
      page.find(:css, "a[role='button']", :text => 'Sign in').click
    end

    # reponse 
    within(:css, '.fyre-login-bar') do
      expect(page).to have_selector(:css, "a[role='button']", :text => user2_id)
    end

    #page.save_screenshot('screenshot_step_7.png')
    # *** STOP EDITING HERE ***

  end

  step id: 8,
      action: "Click on 'Most Helpful' sort option then click 'Newest' option",
      response: "Do you see user1's most recent comment shows up?" do
    # *** START EDITING HERE ***

    # Currently there is a bug that prevents using the latest because it takes 10 minutes for the Post to show up
    # action
    #within(:css, '.fyre-widget') do
    #  page.find(:css, '.fyre-reviews-write').hover
    #end

    #within(:css, '.fyre-stream-sort') do
    #  page.find(:css, 'label', :text => 'Most helpful').click
    #  page.find(:css, 'a', :text => 'Newest').click
    #end

    # response
    expect(page).to have_selector(:css, "article[data-author-id^='#{user1_id}']")

    #page.save_screenshot('screenshot_step_8.png')
    # *** STOP EDITING HERE ***

  end

  step id: 9,
      action: "Click on the '...More' option.",
      response: "Do you see 'Flag' option from the drop down ?" do

    # *** START EDITING HERE ***
    

    # action
    within(:css, "article[data-author-id^='#{user1_id}']") do
      page.find(:css, "a", :text => 'More').click
    end
    
    # response
    within(:css, '.fyre-actions-menu') do
      expect(page).to have_selector(:css, "li", :text => 'Flag')
    end

    #page.save_screenshot('screenshot_step_9.png')
    # *** STOP EDITING HERE ***

  end

  
  step id: 10,
      action: "Click the 'Flag' option from the drop down",
      response: "Do you see 'Flag' window opens ?" do

    # *** START EDITING HERE ***

    # action
    within(:css, '.fyre-actions-menu') do
      page.find(:css, "li", :text => 'Flag').click
    end

    # response
    within(:css, '.fyre-modal') do   
      expect(page).to have_content("Flag #{user1_id}'s review")
    end

    #page.save_screenshot('screenshot_step_10.png')
    # *** STOP EDITING HERE ***

  end

  step id: 11,
      action: "Click the 'Flag' option from the drop down",
      response: "Do you see 'Flag' window opens ?" do

    # *** START EDITING HERE ***

    # action
    within(:css, '.fyre-modal') do   
      expect(page.find(:css, "option[selected='selected']")['value']).to eql('none')
      page.select 'Offensive', :from => 'flagType'    
    end

    within(:css, '.fyre-modal') do   
      expect(page).to have_content('Offensive')
    end

    #page.save_screenshot('screenshot_step_10.png')
    # *** STOP EDITING HERE ***

  end

  step id: 12,
      action: "Click the '1 Reply' option again.",
      response: "Do you see Reply comment widget closes ? " do
   
    # *** START EDITING HERE ***
    
    # action
    within(:css, '.fyre-modal') do
      page.find(:css, 'button', :text => 'OK').click
    end

    # response
    expect(page).to have_content('Review has been flagged.', wait: 10)

    #page.save_screenshot('screenshot_step_11.png')
    # *** STOP EDITING HERE ***

  end

  page.find(:css, "a[role='button']", :text => user2_id).hover
  page.find(:css, "a[role='button']", :text => 'Sign out').click
 
end
