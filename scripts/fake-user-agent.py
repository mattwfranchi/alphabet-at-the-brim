from fake_useragent import UserAgent

import sys 

if __name__ == '__main__':

    ua = UserAgent(os='windows', min_percentage=10.0)
    print(ua.random)
    
    sys.exit(0)