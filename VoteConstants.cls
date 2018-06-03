public with sharing class VoteConstants {
        
    // Constant for timer expiration in mins
    public static final Integer MAX_TIMER_COUNT = 5;
    public static final String SYSTEM_USER = '0057F000003y2eR';
    public static final String SECRET_KEY = 'DNf32sdsj747dhkjd8893jjjdjds7jjk';
    
    //constant for date Format
    public static final String DATE_FORMAT  = 'M/d/yyyy hh:mm aaa';
    public static final String JS_DATE_FORMAT  = 'MMMMM dd,yyyy HH:mm:ss';

    public static final String SLOT_NOT_STARTED = 'SLOT_NOT_STARTED';
    public static final String SLOT_ENDED = 'SLOT_ENDED';
    public static final String SLOT_TIMEOUT = 'SLOT_TIMEOUT';
    public static final String ALREADY_VOTED = 'SINGLE_VOTE';
    public static final String SLOT_INVALID = 'SLOT_INVALID';
    public static final String INVALID_USER = 'INVALID_USER';
}