;  00000000011111111112222222HHHLL3
;  12345678901234567890123456HHHLL2
;0  ***** *****  **** *****
;1    *   *     *       *
;2    *   *     *       *
;3    *   ***** *       *
;4    *   *     *       *
;5    *   *     *       *
;6    *   *****  ****   *

Loop0:	blank	   ; 1  
	point      ; 2  *
	point      ; 3  *
	point      ; 4  * 
	point      ; 5  *
	point      ; 6  *
	blank      ; 7   
	point      ; 8  *
	point      ; 9  *
	point      ; 10 *
	point      ; 11 *
	point      ; 12 *
	blank      ; 13  
	blank      ; 14  
	point      ; 15 *
	point      ; 16 *
	point      ; 17 *
	point      ; 18 *
	blank      ; 19  
	point      ; 20 *
	point      ; 21 *
	point      ; 22 *
	point      ; 23 *
	point	   ; 24 *
	blank	   ; 25  
	blank      ; 26  

	HSync      ; 27-29

	decfsz  LCount0       ; 30
	goto    Loop0         ; 31
	nop	   ; 32

Loop1:	blank	   ; 1   
	blank      ; 2   
	blank      ; 3   
	point      ; 4  * 
	blank      ; 5   
	blank      ; 6   
	blank      ; 7   
	point      ; 8  *
	blank      ; 9   
	blank      ; 10  
	blank      ; 11  
	blank      ; 12
	blank      ; 13  
	point      ; 14 *
	blank      ; 15  
	blank      ; 16  
	blank      ; 17 
	blank      ; 18  
	blank      ; 19  
	blank      ; 20  
	blank      ; 21  
	point	   ; 22 *
	blank      ; 23 
	blank      ; 24  
	blank      ; 25  
	blank	   ; 26  

	HSync      ; 27-29

	decfsz  LCount1       ; 30
	goto    Loop1         ; 31
	nop	   ; 32

Loop2:	blank	   ; 1   
	blank      ; 2   
	blank      ; 3   
	point      ; 4  * 
	blank      ; 5   
	blank      ; 6   
	blank      ; 7   
	point      ; 8  *
	blank      ; 9   
	blank      ; 10  
	blank      ; 11  
	blank      ; 12
	blank      ; 13  
	point      ; 14 *
	blank      ; 15  
	blank      ; 16  
	blank      ; 17 
	blank      ; 18  
	blank      ; 19  
	blank      ; 20  
	blank      ; 21  
	point	   ; 22 *
	blank      ; 23 
	blank      ; 24  
	blank      ; 25  
	blank	   ; 26  

	HSync      ; 27-29

	decfsz  LCount2       ; 30
	goto    Loop2         ; 31
	nop	   ; 32

Loop3:	blank	   ; 1   
	blank      ; 2   
	blank      ; 3   
	point      ; 4  * 
	blank      ; 5   
	blank      ; 6   
	blank      ; 7   
	point      ; 8  *
	point      ; 9  *
	point      ; 10 *
	point      ; 11 *
	point      ; 12 *
	blank      ; 13  
	point      ; 14 *
	blank      ; 15  
	blank      ; 16  
	blank      ; 17 
	blank      ; 18  
	blank      ; 19  
	blank      ; 20  
	blank      ; 21  
	point	   ; 22 *
	blank      ; 23 
	blank      ; 24  
	blank      ; 25  
	blank	   ; 26  

	HSync      ; 27-29

	decfsz  LCount3       ; 30
	goto    Loop3         ; 31
	nop	   ; 32

Loop4:	blank	   ; 1   
	blank      ; 2   
	blank      ; 3   
	point      ; 4  * 
	blank      ; 5   
	blank      ; 6   
	blank      ; 7   
	point      ; 8  *
	blank      ; 9   
	blank      ; 10  
	blank      ; 11  
	blank      ; 12
	blank      ; 13  
	point      ; 14 *
	blank      ; 15  
	blank      ; 16  
	blank      ; 17 
	blank      ; 18  
	blank      ; 19  
	blank      ; 20  
	blank      ; 21  
	point	   ; 22 *
	blank      ; 23 
	blank      ; 24  
	blank      ; 25  
	blank	   ; 26  

	HSync      ; 27-29

	decfsz  LCount4       ; 30
	goto    Loop4         ; 31
	nop	   ; 32

Loop5:	blank	   ; 1   
	blank      ; 2   
	blank      ; 3   
	point      ; 4  * 
	blank      ; 5   
	blank      ; 6   
	blank      ; 7   
	point      ; 8  *
	blank      ; 9   
	blank      ; 10  
	blank      ; 11  
	blank      ; 12
	blank      ; 13  
	point      ; 14 *
	blank      ; 15  
	blank      ; 16  
	blank      ; 17 
	blank      ; 18  
	blank      ; 19  
	blank      ; 20  
	blank      ; 21  
	point	   ; 22 *
	blank      ; 23 
	blank      ; 24  
	blank      ; 25  
	blank	   ; 26  

	HSync      ; 27-29

	decfsz  LCount5       ; 30
	goto    Loop5         ; 31
	nop	   ; 32

Loop6:	blank	   ; 1   
	blank      ; 2   
	blank      ; 3   
	point      ; 4  * 
	blank      ; 5   
	blank      ; 6   
	blank      ; 7   
	point      ; 8  *
	point      ; 9  *
	point      ; 10 *
	point      ; 11 *
	point      ; 12 *
	blank      ; 13  
	blank      ; 14  
	point      ; 15 *
	point      ; 16 *
	point      ; 17 *
	point      ; 18 *
	blank      ; 19  
	blank      ; 20  
	blank      ; 21  
	point	   ; 22 *
	blank      ; 23 
	blank      ; 24  
	blank      ; 25  
	blank	   ; 26  

	HSync      ; 27-29
	
	decfsz  LCount6       ; 30
	goto    Loop6         ; 31
	nop	   ; 32
