#!/bin/bash  

(nohup ruby main.rb repo0 > output0 2>1& & )&
(nohup ruby main.rb repo1 > output1 2>1& & )&
(nohup ruby main.rb repo2 > output2 2>1& & )&
(nohup ruby main.rb repo3 > output3 2>1& & )&
(nohup ruby main.rb repo4 > output4 2>1& & )&
