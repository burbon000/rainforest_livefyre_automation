#tester starts at 
# https://lemonsarebetter.herokuapp.com/widget.php?network=rainforestqa.fyre.co&site=383920&articleId=ekrfjherf34823&appType=reviews&userId=user1_9080908090


test(id: 27781, title: "Like") do
  # You can use any of the following variables in your code:
  # - []
  Capybara.save_path = "like_test/"
  random_num = rand(100000000...999999999).to_s
  username_a = 'rftester483'
  password_a = ''
  username_b = 'rftester927'
  password_b = ''

  base_url = "https://lemonsarebetter.herokuapp.com/widget.php?network=rainforest-lfep.fyre.co"\
    "&site=382781&articleId=#{random_num}&jsVersion=1.1.10"
  
  window = Capybara.current_session.driver.browser.manage.window
  #window.maximize
  visit base_url

  step id: 1,
      action: "Click on the 'Sign in' button/link.",
      response: "Do you see a sign in option?" do
    # *** START EDITING HERE ***

    # action
    page.find(:css, "a[role='button']", :text => 'Sign in').click
    
    # response
    popup = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window(popup)
    expect(page).to have_content('Sign In With Email')

    page.save_screenshot('screenshot_step_1.png')
    # *** STOP EDITING HERE ***
  end

  step id: 2,
      action: "Enter username: '{{commenter_email_account.emaila}}'' and password: '{{commenter_email_account.passworda}}'"\
        " and click the 'Sign In' button.",
      response: "Do you see '{{commenter_email_account.usernamea}}'' in the top left?" do
    # *** START EDITING HERE ***

    # action
    fill_in 'username', with: username_a
    fill_in 'password', with: password_a
    page.find(:css, "input[value='Sign In']").click
    
    # reponse
    main_window = page.driver.browser.window_handles.first
    page.driver.browser.switch_to.window(main_window)
    expect(page).to have_content(username_a)

    page.save_screenshot('screenshot_step_2.png')
    # *** STOP EDITING HERE ***
  end

  step id: 3,
      action: "Click in the textbox, type or copy in 'test comment', then click on the 'Post comment' button.",
      response: "Do you see the comment appear under the textbox?" do
   
    # *** START EDITING HERE ***
    comment = 'Test Comment'
    # action
    within_frame(find(:css, '[aria-label=editor]')) do
      expect(page.find(:css, 'p')['text']).to eql(nil)
      page.find(:css, "body[role='textbox']").click
      page.find(:css, "body[role='textbox']").native.send_keys(comment)
    end
    page.find("div[role='button']", :text => 'Post comment').click

    # response
    within(:css, 'article', :match => :first) do
      expect(page).to have_content(comment)
      expect(page).to have_content(username_a)
    end

    page.save_screenshot('screenshot_step_3.png')
    # *** STOP EDITING HERE ***
  end

  step id: 4,
      action: "In the top left, hover over '{{commenter_email_account.usernamea}}' and click on 'Sign out'",
      response: "Does the text 'Sign in' appear in the top left?" do
    
    # *** START EDITING HERE ***
 
    # action
    page.find(:css, "a[role='button']", :text => username_a).hover
    page.find(:css, "a[role='button']", :text => 'Sign out').click

    # response
    expect(page).to have_content('Sign in')

    page.save_screenshot('screenshot_step_4.png')
    # *** STOP EDITING HERE ***
  end

  step id: 5,
      action: "Click on the 'Sign in' button/link.",
      response: "Do you see a sign in option?" do
   
    # *** START EDITING HERE ***
    
    # action
    page.find(:css, "a[role='button']", :text => 'Sign in').click
    
    # response
    popup = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window(popup)
    expect(page).to have_content('Sign In With Email')

    page.save_screenshot('screenshot_step_5.png')
    # *** STOP EDITING HERE ***
  end

  step id: 6,
      action: "Enter username: '{{commenter_email_account.emailb}}'' and password: '{{commenter_email_account.passwordb}}' "\
        "and click the 'Sign In' button.",
      response: "Do you see '{{commenter_email_account.usernameb}}'' in the top left?" do
      
    # *** START EDITING HERE ***
    
    # action
    fill_in 'username', with: username_b
    fill_in 'password', with: password_b
    page.find(:css, "input[value='Sign In']").click
    
    # reponse
    main_window = page.driver.browser.window_handles.first
    page.driver.browser.switch_to.window(main_window)
    expect(page).to have_content(username_b)

    page.save_screenshot('screenshot_step_6.png')
    # *** STOP EDITING HERE ***

  end
  
 step id: 7,
      action: "Click the 'Like' text button to the right of the comment 'test comment'. Refresh the page.",
      response: "Do you see the text 'Unlike' to the right of the comment 'test comment'?" do

    # *** START EDITING HERE ***

    # action
    within(:css, 'article', :match => :first) do
      page.find(:css, 'a', :text => 'Like').click
    end

    # reponse 
    within(:css, 'article', :match => :first) do
      expect(page).to have_content('Unlike')
      expect(page).to have_content(username_a)
    end

    page.save_screenshot('screenshot_step_7.png')
    # *** STOP EDITING HERE ***

  end

  page.find(:css, "a[role='button']", :text => username_b).hover
  page.find(:css, "a[role='button']", :text => 'Sign out').click
  #sleep(10)

end
