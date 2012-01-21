
# WBNotificationView  

A first attempt to adapt Twitter's [Bootstrap](http://twitter.github.com/bootstrap) toolkit for iOS. 

*Example code*  

	notificationView = [[WBNotificationView alloc] initWithMessage:nil ofType:WBNotificationViewTypeError];
	[self.view addSubview:notificationView];
	[notificationView slideIn];  
	
## API  

	- (id)initWithMessage:(NSString *)message ofType:(WBNotificationViewType)type;
	- (void)slideIn;
	- (void)slideOut;
	- (void)slideInDisappearingIn:(NSTimeInterval)seconds;  

## Installation

Just drag WBNotificationView's .h and .m files to your Xcode project. 
	
## TODO  

* Finished documentation  
* Add close icon  
* Fix UILabel width issue  
* Use [TTTAttributedLabel](https://github.com/wilhelmbot/TTTAttributedLabel) on NotificationView  
* Style buttons  

## License 

(The MIT License)

Copyright (c) 2012 Rod Wilhelmy &lt;rwilhelmy@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
