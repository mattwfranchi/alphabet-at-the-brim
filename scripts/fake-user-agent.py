from fake_useragent import UserAgent

import sys 

if __name__ == '__main__':

    ua = UserAgent(os='windows', browsers=['edge','chrome'], min_percentage=1.5)
    print(ua.random)
    
    sys.exit(0)