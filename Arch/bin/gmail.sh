
#!/bin/bash

USER=thiagors1983@gmail.com
PASS=bucetanomeupau

COUNT=`curl -su $USER:$PASS https://mail.google.com/mail/feed/atom || echo "<ful
lcount>unknown number of</fullcount>"`
COUNT=`echo "$COUNT" | grep -oPm1 "(?<=<fullcount>)[^<]+" `
echo $COUNT
if [ "$COUNT" != "0" ]; then
   if [ "$COUNT" = "1" ];then
      WORD="mail";
   else
      WORD="mails";
   fi
fi

