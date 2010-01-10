from APNSWrapper import APNSNotificationWrapper, APNSNotification, APNSAlert
from optparse import OptionParser
import logging
import sys
import binascii

class Notification:
    def __init__(self, certificate, devel, token):
        self.apns = APNSNotificationWrapper(certificate, sandbox=devel)
        self.msg = APNSNotification()
        self.msg.token(token)
        
    def badgeupdate(self, badge):
        self.msg.badge(badge)
        
    def alertmessage(self, message):
        self.msg.alert(message)
#        alert = APNSAlert()
#       alert.body(message)
#        alert.loc_key("ALERTMSG")
#        alert.action_loc_key("OPEN")
#        m.alert(alert)
        
    def send(self):
        self.apns.append(self.msg)
        self.apns.notify();

if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG, format="%(name)-15s: [%(lineno)4d] %(levelname)-8s %(message)s")
    log = logging.getLogger(__file__)    
    parser = OptionParser()
    parser.add_option("-t", "--token", type="string", dest="token", help="Device Token from iPhone", metavar="TOKEN")
    parser.add_option("-b", "--badge", type="int", dest="badge", default=-1, help="Set badge number", metavar="NUM")
    parser.add_option("-m", "--message", type="string", dest="message", help="message for alert", metavar="STR")
    parser.add_option("-d", "--devel", dest="devel", action="store_true", default=False, help="use development APNS server", metavar="TRUE")
    parser.add_option("-c", "--certificate", type="string", dest="cert", help="certificate to use", metavar="FILE")
    (options, args) = parser.parse_args()
    
    if not options.cert:
        log.warning("No certificate specified, use -c")
        sys.exit(1)
        
    if not options.token:
        log.warning("No token specified, use -t")
        sys.exit(1)
        
    if options.badge == -1 and not options.message:
        log.warning("You need to define -b or -m")
        sys.exit(1)
    
    notif = Notification(options.cert, options.devel, binascii.unhexlify(options.token))
    
    if options.devel:
        log.info("Using sandbox")
        
    if options.badge != -1:
        log.info("Doing badgeupdate: %d", options.badge)
        notif.badgeupdate(options.badge)
        
    if options.message:
        log.info("Sending alert: %s", options.message)
        notif.alertmessage(options.message)
    
    log.info("Sending...")
    notif.send()
    log.info("done!")
            
    
    