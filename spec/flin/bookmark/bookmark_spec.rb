require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

# require File.dirname(__FILE__) + '/../../spec_helper.rb'

include Flin

describe Bookmark do
  
 before(:each) do
   path = %w{.. .. .. data urlsink.yml}
    @bmks = Bookmark.new(path)
 end
 
 subject {@bmks}
 
 context "instantiation without any arguments" do
   specify {lambda {Bookmark.new}.should raise_error}
   specify {lambda {Bookmark.new("moo")}.should_not raise_error(ArgumentError)}
 end
 
 context "all entries in one accessor" do
   specify {@bmks.entries.should be_a_kind_of(Hash)}
 end
 
 context "bookmark entries from data" do
   specify {lambda {IO.read("../../data/urlsink.yml").should eql("nosql rails: http://nosql.mypopescu.com/tagged/rails\nnosql: http://nosql.mypopescu.com/post/407159447/cassandra-twitter-an-interview-with-ryan-king\nold introduction to rspec: http://blog.davidchelimsky.net/2007/05/14/an-introduction-to-rspec-part-i\nrecent development of rspec: http://blog.davidchelimsky.net\ngem development tutorial: http://effectif.com/ruby/manor/gem-this\ntricks for installiing rails3: http://oscardelben.com/install-rails-3\nrubygems manual: http://docs.rubygems.org/read/book/2\nrailsfire: http://www.railsfire.com/article/cassandra-and-ruby-love-affair-key-value-stores-part-3\nbundler gem: http://yehudakatz.com/2010/02/09/using-bundler-in-real-life/\nrails and merb merge: http://www.engineyard.com/blog/2009/rails-and-merb-merge-the-anniversary-part-1-of-6/\narchlinux: http://wiki.archlinux.org/index.php/Setting_Up_Git_ACL_Using_gitosis\nsope opengroup: http://sope.opengroupware.org/en/docs/index.html\ncocoa dev center: http://cocoadevcentral.com/articles/000081.php\npush technology: http://en.wikipedia.org/wiki/Push_technology\noutside-in development: http://www.slideshare.net/josephwilk/outsidein-development-with-cucumber-and-rspec\ndico french: http://www.mediadico.com/dictionnaire/definition/kitch/1\nintroduction to concurrency control: http://www.agiledata.org/essays/concurrencyControl.html\nagile data: http://www.agiledata.org\nrails ar_mailer: http://www.ameravant.com/posts/sending-tons-of-emails-in-ruby-on-rails-with-ar_mailer\ndatabase courses: http://www.inf.ed.ac.uk/teaching/courses/adbs/#prerequisites\ndatabase Systems: http://homepages.inf.ed.ac.uk/libkin/teach/dbs09/index.html\nmacports and ruby 1.9: http://www.ruby-forum.com/topic/178659\nrails and test: http://saucelabs.com/blog/index.php/2010/02/running-selenium-tests-for-rails\nautotest: http://ph7spot.com/musings/getting-started-with-autotest\nautotest for javascript: http://monket.net/blog/tag/autotest\nautotest doc: http://ph7spot.com/musings/getting-started-with-autotest#create_a__file\nyaml tutorial: http://www.yaml.de/en/\nruby installation: http://blog.plainprogrtams.com/a-workable-ruby-development-environment-on-os\ngitosis+github: http://bl.ogtastic.com/2008/8/2/mirroring-to-github\ngitosis: http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way\nrake tutotial: http://svarovsky-thomas.com/rake.html\nhelp haiti: http://helphaiti.org\nread ruby: http://ruby.runpaint.org")}}
 end

 context "check the existence of a given title in entry" do
   specify {@bmks.should respond_to(:exists_entry_with_title?)}
   specify {@bmks.exists_entry_with_title?("Che Guevara").should be_false}
   specify {@bmks.exists_entry_with_title?("nosql").should be_true}
 end
 
 context "add bookmark entry" do
   specify {@bmks.should respond_to(:add)}
    
   specify {@bmks.add("Jose Me", "http://www.princecom.com", :new).should eql("New bookmark entry successfully added!")}
   specify {@bmks.add("NoSQL", "http://nosqlmovement.com", :new).should eql("Sorry! A bookmark entry with this title already exists!")}
   specify {@bmks.add("Clojure", "http://clojure.org").should eql("Bookmark entry successfully extended!")}
 end
 
 context "update entries" do
   specify {@bmks.should respond_to(:update)}
      
   specify {@bmks.update("Another NoSQL", "http://nosqlmovement.com", "http://anothernosql.com").should eql("Sorry! There is no bookmark entry with this title")}
   specify {@bmks.update("yaml tutorial", "http://yaml.kwiki.org", "http://anotheryamltutorial.com").should eql("Sorry! The old url has never been attached to the title")}
   specify {@bmks.update("yaml tutorial", "http://www.yaml.de/en/","http://yaml.kwiki.org" ).should eql("Bookmark entry successfully updated!")}
 end
 
 context "delete entries" do
   specify {@bmks.should respond_to(:delete)}
         
   specify {@bmks.delete("Another NoSQL", "http://nosqlmovement.com").should eql("Sorry! There is no bookmark entry with this title")}
   specify {@bmks.delete("yaml tutorial", "http://anotheryamltutorial.com").should eql("Sorry! The url has never been attached to the title")}
   specify {@bmks.delete("yaml tutorial", "http://www.yaml.de/en/" ).should eql("Bookmark entry successfully deleted!")}
 end
 
 context "get entries" do
   specify {@bmks.should respond_to(:get)}
            
   specify {@bmks.get("Another NoSQL").should eql("Sorry! There is no bookmark entry with this title")}
   specify {@bmks.get("yaml tutorial").should eql("http://www.yaml.de/en/")}
 end
 
 context "save local bookmarks" do
   specify {@bmks.should respond_to(:save)}
   
   specify {@bmks.save.should eql("Bookmark entries successfully stored locally!")}
 end
 
  context "sync to central batabase" do
    specify {@bmks.should respond_to(:sync_db)}
    
    specify {@bmks.sync_db('10.0.1.2', 11211).should eql("Local bookmarks successfully synced with database!")}
  end
  
 context "Argument Error detection" do
   specify {lambda {@bmks.exists_entry_with_title?("Che Guevara")}.should_not raise_error(ArgumentError)}
   specify {lambda {@bmks.exists_entry_with_title?}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.exists_entry_with_title?(1)}.should raise_error(ArgumentError)}
   
   specify {lambda {@bmks.add("Kpax", "http://www.kpaxian.com")}.should_not raise_error(ArgumentError)}
   specify {lambda {@bmks.add("Lebowski", "http://elduderino.net", :extend)}.should_not raise_error(ArgumentError)}
   
   specify {lambda {@bmks.add("Kpax")}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.add(1)}.should raise_error(ArgumentError)}
   
   specify {lambda {@bmks.add("Kpax", 1)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.add(1, "http://www.elduderino.com")}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.add(1, 1)}.should raise_error(ArgumentError)}
   
   specify {lambda {@bmks.add("Lebowski", "http://www.elduderino.com", 1)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.add(1, "http://www.elduderino.com", :new)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.add("Lebowski", 1, :new)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.add(1, 1, 1)}.should raise_error(ArgumentError)}
   
   
   specify {lambda {@bmks.update("NoSQL", "http://nosql.mypopescu.com/post/407159447/cassandra-twitter-an-interview-with-ryan-king", "http://nosqlmovement.com")}.should_not raise_error(ArgumentError)}
   specify {lambda {@bmks.update("Kpax")}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.update("http://me.com")}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.update("Me", "http://me.com")}.should raise_error(ArgumentError)}   
   specify {lambda {@bmks.update(1)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.update("Kpax", 1)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.update(1, "http://www.kpaxian.com")}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.update(1, 1)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.update("Kpax", "http://www.kpaxian.com", 1)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.update(1, "http://www.kpaxian.com", 1)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.update("Kpax", 1, 1)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.update(1, 1, 1)}.should raise_error(ArgumentError)}
   
   specify {lambda {@bmks.delete("Me", "http://me.com")}.should_not raise_error(ArgumentError)}
   specify {lambda {@bmks.delete("Kpax")}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.delete("http://me.com")}.should raise_error(ArgumentError)}
   
   specify {lambda {@bmks.delete(1)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.delete("Kpax", 1)}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.delete(1, "http://www.me.com")}.should raise_error(ArgumentError)}
   specify {lambda {@bmks.delete(1, 1)}.should raise_error(ArgumentError)}
   
   specify {lambda {@bmks.get("Me")}.should_not raise_error(ArgumentError)}
   specify {lambda {@bmks.get(1)}.should raise_error(ArgumentError)}
 end
 
 context "Runtime Error detection" do
   specify {lambda {@bmks.add("Another Me", "http://www.anotherme.com")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.add("Another Me", "https://www.anotherme.com")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.add("Another Me", "git://anotherme.com/me")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.add("Another Me", "ftp://anotherme.com/")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.add("Another Me", "file://anotherme.com/my/other/folder")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.add("Another You", "htp://www.anotheryou.com")}.should raise_error(RuntimeError)}
   specify {lambda {@bmks.add("Another You", "htps://www.anotheryou.com")}.should raise_error(RuntimeError)}
   
   specify {lambda {@bmks.update("Another Me", "http://www.anotherme.com","http://www.anothermoi.org")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.update("Another Me", "https://www.anotherme.com", "https://www.anotherme.net")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.update("Another Me", "git://anotherme.com/me", "git://anotherme.info/me")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.update("Another Me", "ftp://anotherme.com/", "ftp://anotherme.org/")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.update("Another Me", "file://anotherme.com/my/other/folder", "file://anotherme.org/my/other/folder")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.update("Another You", "htp://www.anotheryou.com", "htp://www.anotheryou.net")}.should raise_error(RuntimeError)}
   specify {lambda {@bmks.update("Another You", "htps://www.anotheryou.com", "htp://www.anotheryou.net")}.should raise_error(RuntimeError)}
   
   specify {lambda {@bmks.delete("Another Me", "http://www.anotherme.com")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.delete("Another Me", "https://www.anotherme.com")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.delete("Another Me", "git://anotherme.com/me")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.delete("Another Me", "ftp://anotherme.com/")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.delete("Another Me", "file://anotherme.com/my/other/folder")}.should_not raise_error(RuntimeError)}
   specify {lambda {@bmks.delete("Another You", "htp://www.anotheryou.com")}.should raise_error(RuntimeError)}
   specify {lambda {@bmks.delete("Another You", "htps://www.anotheryou.com")}.should raise_error(RuntimeError)}      
 end       
end