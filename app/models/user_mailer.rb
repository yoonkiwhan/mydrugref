class UserMailer < ActionMailer::Base

  def greeting(user)
    @subject = 'Welcome to MyDrugRef'
    @body = {}
    @body["user"] = user
    @recipients = user["email"]
    @from = 'MyDrugRef <do-not-reply@dev2.mydrugref.org>'
  end

end