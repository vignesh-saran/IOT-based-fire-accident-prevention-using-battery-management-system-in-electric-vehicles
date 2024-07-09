function send_mail_message(id,subject,message,attachment)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Your gmail ID and password 
%(from which email ID you would like to send the mail)

mail = 'sampletestmail.786@gmail.com';    %Your GMail email address
password = 'vnzymrxlzmdyurch';          %Your GMail password

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 1
    message = subject;
    subject = '';
elseif nargin == 2
    message = '';
    attachment = '';
elseif nargin == 3
    attachment = '';
end

% Send Mail ID
emailto = strcat(id);
%% Set up Gmail SMTP service.
% Then this code will set up the preferences properly:
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

% Gmail server.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

%% Send the email
if strcmp(mail,'anbufantazy@gmail.com')
    disp('Please provide your own gmail.')
    disp('--Mail Sent--')

end

sendmail(emailto,subject,message,attachment)
disp('Mail Sent to...');
disp(id);

end
