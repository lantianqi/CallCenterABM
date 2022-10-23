globals [
  ; num-of-staff        ; how many staff are working in the call center
  ; ratio-of-vips       ; the ratio of vip clients to all clients
  last-call-in          ; the tick at which the last call-in arrived
  ; mean-inter-arrival  ; the mean length of interval between arrivals of two call-in clients
  total-served          ; total number of clients served in the day
  total-missed          ; total number of clients who waited longer than their tolerance and left without being served
  total-satisfaction    ; total degree of satisfaction of all clients served

  mean-tolerance        ;
  mean-patience         ;
  mean-willing-to-wait  ;
  mean-service-time

  num-of-cur-waiting    ; number of currently waiting clients
  normal-cur-waiting-queue    ; currently normal clients waiting queue with the client service time
  vip-cur-waiting-queue   ; currently vip clients waiting queue with the client service time
  normal-cur-waiting-queue-with-id    ; currently normal clients waiting queue with the client service time
  vip-cur-waiting-queue-with-id   ; currently vip clients waiting queue with the client service time



]

breed [staff a-staff]
breed [clients client]

turtles-own [

  client-id          ;
  is-vip             ;
  service-time       ;
  waiting-time       ;
  tolerance          ;
  patience           ;
  satisfaction       ;
  willing-to-wait    ;

  rest-service-time       ;

]

to setup
  ca

  set mean-tolerance 15
  set mean-patience 1
  set mean-willing-to-wait 10
  set num-of-cur-waiting 0
  set mean-service-time 10
  set normal-cur-waiting-queue []
  set normal-cur-waiting-queue-with-id []
  set vip-cur-waiting-queue []
  set vip-cur-waiting-queue-with-id []

  setup-staff
  reset-ticks

end

to setup-staff
  let staff-interval (world-width /(num-of-staff + 1))
  create-staff num-of-staff [
    set color yellow
    set heading 180
    setxy (min-pxcor - 0.5 + staff-interval * (1 + who)) (max-pycor - 0.5)
    set rest-service-time 0
  ]
end


to go
  let interval (random-normal mean-inter-arrival (mean-inter-arrival / 4))

  if (ticks - last-call-in) >= interval [
    create-client
    ;set num-of-cur-waiting num-of-cur-waiting + 1
    ;print num-of-cur-waiting
  ]

  ;write "tick:" print ticks
  ;write "lenght:" print length normal-cur-waiting-queue
  if (length normal-cur-waiting-queue >= 1) or (length vip-cur-waiting-queue >= 1) [
    ;write "normal" print length normal-cur-waiting-queue
    ;write "vip" print length vip-cur-waiting-queue
    ;write "normal queue: " print normal-cur-waiting-queue
    ;write "vip queue: " print vip-cur-waiting-queue
    ask staff [service]]
  ask clients [patient-checking]

  tick


end


to create-client
  create-clients 1 [
    ; set the variables of this client


    setxy (min-pxcor ) (min-pycor )
    set client-id num-of-cur-waiting
    set service-time random-normal mean-service-time (mean-service-time / 4 )

    ifelse random 100 < ratio-of-vips [
      set is-vip true
      set vip-cur-waiting-queue lput service-time vip-cur-waiting-queue
      set vip-cur-waiting-queue-with-id  lput client-id normal-cur-waiting-queue-with-id

    ]
    [
      set is-vip false
      set normal-cur-waiting-queue lput service-time normal-cur-waiting-queue
      set normal-cur-waiting-queue-with-id  lput client-id vip-cur-waiting-queue-with-id
    ]

    ;print (word ticks "\t" "interval:" "\t" (ticks - last-call-in) "\t" is-vip)

    set tolerance random-normal mean-tolerance ( mean-tolerance / 4 )
    set patience random-normal mean-patience ( mean-patience / 4 )
    set willing-to-wait random-normal mean-willing-to-wait ( mean-willing-to-wait / 4 )

    set num-of-cur-waiting num-of-cur-waiting + 1
    set last-call-in ticks
   ;print last-call-in

  ]

end

to service
  ifelse rest-service-time <= 0  ;one staff is available
  [
    ;write "staff:" print rest-service-time
    ifelse (length vip-cur-waiting-queue) = 0 [  ; if vip queue is empty
    ifelse length normal-cur-waiting-queue = 0 [stop]    ;if both vip and normal queue empty, no client is waiting, no need to service
    [ ;print length normal-cur-waiting-queue
      set rest-service-time first normal-cur-waiting-queue
      ;print normal-cur-waiting-queue
      set normal-cur-waiting-queue remove-item 0 normal-cur-waiting-queue    ;serve the first client in the queue
      
        
      ask clients with [client-id = first normal-cur-waiting-queue-with-id][die]
      
      set normal-cur-waiting-queue remove-item 0 normal-cur-waiting-queue
      ;write "staff new:" print rest-service-time
    ]

   ]
    [set rest-service-time first vip-cur-waiting-queue
     ask clients with [client-id = first vip-cur-waiting-queue-with-id][die]
     set vip-cur-waiting-queue remove-item 0 vip-cur-waiting-queue
     
    ]
    
    set num-of-cur-waiting num-of-cur-waiting - 1
  ]

  [set rest-service-time rest-service-time - 1]

end


to patient-checking
  write "ticks" print ticks
  print last-call-in
  ;set waiting-time (ticks - last-call-in)
  ;print waiting-time

end
;
