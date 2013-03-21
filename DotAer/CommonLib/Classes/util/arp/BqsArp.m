//
//  BqsArp.m
//  TVGuide
//
//  Created by ellison on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include "BqsArp.h"
#include <sys/param.h>
#include <sys/file.h>
#include <sys/socket.h>
#include <sys/sysctl.h>

#include <net/if.h>

#include "if_ether.h"
#include "route.h"
#include "if_arp.h"
#include "if_dl.h"
#include <netinet/in.h>


#include <arpa/inet.h>

#include <err.h>
#include <errno.h>
#include <netdb.h>

#include <paths.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern  int iptomac(const char* ip, unsigned char* mac) { 
    
    if(NULL == ip || NULL == mac) {
        return -1;
    }
    
    memset(mac, 0, 6);

    int /*expire_time, flags, export_only, doing_proxy,*/ found_entry, nflag; 
    u_long addr = inet_addr(ip); 
    int mib[6]; 
    size_t needed; 
    char *host, *lim, *buf, *next; 
    struct rt_msghdr *rtm; 
    struct sockaddr_inarp *sin; 
    struct sockaddr_dl *sdl; 
    extern int h_errno; 
    struct hostent *hp; 
    
    mib[0] = CTL_NET; 
    mib[1] = PF_ROUTE; 
    mib[2] = 0; 
    mib[3] = AF_INET; 
    mib[4] = NET_RT_FLAGS; 
    mib[5] = RTF_LLINFO; 
    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0)  {
        return -2;
    }
    if ((buf = malloc(needed)) == NULL) {
        return -3;
    }
    if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0) {
        free(buf);
        return -4;
    }
    
    
    lim = buf + needed; 
    for (next = buf; next < lim; next += rtm->rtm_msglen) { 
        rtm = (struct rt_msghdr *)next; 
        sin = (struct sockaddr_inarp *)(rtm + 1); 
        sdl = (struct sockaddr_dl *)(sin + 1); 
        if (addr) { 
            if (addr != sin->sin_addr.s_addr) 
                continue; 
            found_entry = 1; 
        } 
        if (nflag == 0) 
            hp = gethostbyaddr((caddr_t)&(sin->sin_addr), 
                               sizeof sin->sin_addr, AF_INET); 
        else 
            hp = 0; 
        if (hp) 
            host = hp->h_name; 
        else { 
            host = "?"; 
            if (h_errno == TRY_AGAIN) 
                nflag = 1; 
        } 
        
        
        
        if (sdl->sdl_alen) { 
            
            char *cp = LLADDR(sdl); 
            
            memcpy(mac, cp, 6);
        } 
    } 
    
    free(buf);
    
    if (found_entry == 0) { 
        return 0; 
    } else { 
        return -5;
    } 
} 