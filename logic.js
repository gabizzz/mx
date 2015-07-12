function getTimeFromMSec(msec)
{
         if (msec <= 0 || msec === undefined) {
             return ""

         } else {
             var sec = "" + Math.floor(msec / 1000) % 60
             if (sec.length == 1)
                 sec = "0" + sec

             var hour = Math.floor(msec / 3600000)
             if (hour < 1) {
                 return Math.floor(msec / 60000) + ":" + sec
             } else {
                 var min = "" + Math.floor(msec / 60000) % 60
                 if (min.length == 1)
                     min = "0" + min

                 return hour + ":" + min + ":" + sec
             }
         }
}


