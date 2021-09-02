-- 테이블 순서는 관계를 고려하여 한 번에 실행해도 에러가 발생하지 않게 정렬되었습니다.

-- USER Table Create SQL
CREATE TABLE IF NOT EXISTS USER
(
    `id`             INT            NOT NULL    AUTO_INCREMENT, 
    `email`          VARCHAR(45)    NOT NULL    COMMENT '사용자 이메일', 
    `name`           VARCHAR(10)    NOT NULL    COMMENT '사용자 명', 
    `pwd`            char(64)       NOT NULL    COMMENT '비밀번호해쉬값', 
    `verifiedPhone`  char(11)       NULL        COMMENT '핸드폰인증', 
    `bankAccount`    varchar(30)    NULL        COMMENT '실계좌번호', 
    `gubun`          CHAR(1)        NULL        COMMENT '카카오,일반계정 구분', 
    `bankType`       CHAR(1)        NULL        COMMENT '은행명', 
    CONSTRAINT PK_USER PRIMARY KEY (id, email)
);

ALTER TABLE USER COMMENT '회원정보_끝';


-- ARTIST Table Create SQL
CREATE TABLE IF NOT EXISTS ARTIST
(
    `id`       INT            NOT NULL    AUTO_INCREMENT, 
    `email`    VARCHAR(45)    NOT NULL    COMMENT '아티스트 계정', 
    `artist`   VARCHAR(45)    NOT NULL    COMMENT '아티스트 명', 
    `comment`  VARCHAR(45)    NULL        COMMENT '아티스트 설명', 
    `imgSrc`   VARCHAR(45)    NULL        COMMENT '아티스트 사진주소', 
    CONSTRAINT PK_ARTIST PRIMARY KEY (id, email)
);

ALTER TABLE ARTIST COMMENT '등록된 아티스트 정보';

ALTER TABLE ARTIST
    ADD CONSTRAINT FK_ARTIST_email_USER_email FOREIGN KEY (email)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- NFT_ALBUM Table Create SQL
CREATE TABLE IF NOT EXISTS NFT_ALBUM
(
    `id`       INT            NOT NULL    AUTO_INCREMENT, 
    `albumID`  INT            NOT NULL    COMMENT '앨범 아이디', 
    `title`    VARCHAR(45)    NOT NULL    COMMENT '앨범명', 
    `comment`  VARCHAR(45)    NULL        COMMENT '앨범소개', 
    `imgSrc`   VARCHAR(30)    NULL        COMMENT '앨범커버', 
     PRIMARY KEY (id, albumID)
);

ALTER TABLE NFT_ALBUM COMMENT 'NFT 음원의 앨범';


-- PRODUCT Table Create SQL
CREATE TABLE IF NOT EXISTS PRODUCT
(
    `id`              INT            NOT NULL    AUTO_INCREMENT, 
    `productID`       INT            NULL        COMMENT '굿즈 아이디', 
    `productName`     VARCHAR(45)    NULL        COMMENT '굿즈 이름', 
    `price`           INT            NULL        COMMENT '굿즈 가격', 
    `productComment`  TEXT           NULL        COMMENT '굿즈 소개', 
    `productDetail`   TEXT           NULL        COMMENT '굿즈 세부설명', 
    `imgSrc`          VARCHAR(30)    NULL        COMMENT '굿즈 아이콘 링크', 
    CONSTRAINT PK_PRODUCT PRIMARY KEY (id, ProductID)
);

ALTER TABLE PRODUCT COMMENT 'NFT 음원에 대한 굿즈_끝';


-- NFT_MUSIC Table Create SQL
CREATE TABLE IF NOT EXISTS NFT_MUSIC
(
    `id`           INT            NOT NULL, 
    `nftID`        INT            NOT NULL    COMMENT 'NFT 아이디', 
    `albumID`      INT            NOT NULL    COMMENT '앨범 아이디', 
    `musicName`    VARCHAR(45)    NOT NULL    COMMENT '음원명', 
    `infoComment`  TEXT           NULL        COMMENT '음원설명', 
    `email`        VARCHAR(45)    NOT NULL    COMMENT '아티스트 계정', 
    `totalSupply`  INT            NOT NULL    COMMENT '최초배포량', 
    CONSTRAINT PK_NFT PRIMARY KEY (id)
);

ALTER TABLE NFT_MUSIC COMMENT 'NFT 음원 정보';

ALTER TABLE NFT_MUSIC
    ADD CONSTRAINT FK_NFT_MUSIC_email_ARTIST_email FOREIGN KEY (email)
        REFERENCES ARTIST (email) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE NFT_MUSIC
    ADD CONSTRAINT FK_NFT_MUSIC_albumID_NFT_ALBUM_albumID FOREIGN KEY (albumID)
        REFERENCES NFT_ALBUM (albumID) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- MARKET Table Create SQL
CREATE TABLE IF NOT EXISTS MARKET
(
    `id`     INT    NOT NULL    AUTO_INCREMENT, 
    `nftID`  INT    NULL, 
    CONSTRAINT PK_MARKET PRIMARY KEY (id)
);

ALTER TABLE MARKET COMMENT '트레이딩 관련';


-- OWNER Table Create SQL
CREATE TABLE IF NOT EXISTS OWNER
(
    `id`      INT            NOT NULL    AUTO_INCREMENT, 
    `nftID`   INT            NOT NULL    COMMENT 'NFT 아이디', 
    `email`   VARCHAR(45)    NOT NULL    COMMENT '사용자 이메일', 
    `volume`  INT            NOT NULL    COMMENT '보유량', 
    CONSTRAINT PK_OWNER PRIMARY KEY (id, nftID)
);

ALTER TABLE OWNER COMMENT 'NFT 별 소유현황';

ALTER TABLE OWNER
    ADD CONSTRAINT FK_OWNER_nftID_NFT_MUSIC_nftID FOREIGN KEY (nftID)
        REFERENCES NFT_MUSIC (nftID) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE OWNER
    ADD CONSTRAINT FK_OWNER_email_USER_email FOREIGN KEY (email)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- FUNDING_LIST Table Create SQL
CREATE TABLE IF NOT EXISTS FUNDING_LIST
(
    `id`             INT            NOT NULL    AUTO_INCREMENT, 
    `fundingID`      INT            NOT NULL    COMMENT '펀딩상품 ID'
    `nftID`          INT            NOT NULL    COMMENT 'NFT 아이디',
    `endDate`        DATETIME       NOT NULL    COMMENT '마감일', 
    `artist`         VARCHAR(45)    NOT NULL    COMMENT '아티스트명', 
    `targetAmount`   INT            NOT NULL    COMMENT '목표금액,달성금액', 
    `currentAmount`  INT            NOT NULL    COMMENT '현재모금된 금액', 
    CONSTRAINT PK_FUND PRIMARY KEY (id, fundingID)
);

ALTER TABLE FUNDING_LIST COMMENT 'NFT 음원 펀딩 리스트들';

ALTER TABLE FUNDING_LIST
    ADD CONSTRAINT FK_FUNDING_LIST_nftID_NFT_MUSIC_nftID FOREIGN KEY (nftID)
        REFERENCES NFT_MUSIC (nftID) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE FUNDING_LIST
    ADD CONSTRAINT FK_FUNDING_LIST_artist_ARTIST_artist FOREIGN KEY (artist)
        REFERENCES ARTIST (artist) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- PLEDGE Table Create SQL
CREATE TABLE IF NOT EXISTS PLEDGE
(
    `id`      INT            NOT NULL    AUTO_INCREMENT, 
    `email`   VARCHAR(45)    NOT NULL    COMMENT '사용자 이메일', 
    `agrees`  VARCHAR(45)    NOT NULL    COMMENT '각각의 동의 항목 체크여부를 Object string형태로 저장', 
    CONSTRAINT PK_PLEDGE PRIMARY KEY (id)
);

ALTER TABLE PLEDGE COMMENT '보안서약서 및 개인정보제공 동의 항목 내용_끝';

ALTER TABLE PLEDGE
    ADD CONSTRAINT FK_PLEDGE_email_USER_email FOREIGN KEY (email)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- USER_NFT_ASSET Table Create SQL
CREATE TABLE IF NOT EXISTS USER_NFT_ASSET
(
    `id`      INT            NOT NULL    AUTO_INCREMENT, 
    `nftID`   VARCHAR(45)    NOT NULL    COMMENT '보유 NFT', 
    `email`   VARCHAR(45)    NOT NULL    COMMENT '사용자 이메일', 
    `volume`  INT            NOT NULL    COMMENT '보유량', 
    CONSTRAINT PK_ASSET PRIMARY KEY (id)
);

ALTER TABLE USER_NFT_ASSET COMMENT '사용자가 가진 NFT 자산';

ALTER TABLE USER_NFT_ASSET
    ADD CONSTRAINT FK_USER_NFT_ASSET_email_USER_email FOREIGN KEY (email)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- CASH_FLOW_LOG Table Create SQL
CREATE TABLE IF NOT EXISTS CASH_FLOW_LOG
(
    `id`        INT            NOT NULL    AUTO_INCREMENT, 
    `email`     VARCHAR(45)    NOT NULL    COMMENT '사용자 이메일', 
    `gubun`     CHAR(1)        NOT NULL    COMMENT '거래구분(0:매수, 1:매도, 2:선물받음, 3:선물보냄)', 
    `balance`   INT            NOT NULL    COMMENT '거래금액', 
    `date`      DATETIME       NOT NULL    COMMENT '거래일(년월일시분초)', 
    `sender`    VARCHAR(45)    NOT NULL    COMMENT '보낸 사람', 
    `receiver`  VARCHAR(45)    NOT NULL    COMMENT '받는 사람', 
    CONSTRAINT PK_CASHFLOWLOG PRIMARY KEY (id, email)
);

ALTER TABLE CASH_FLOW_LOG COMMENT '현금 거래 로그_끝';

ALTER TABLE CASH_FLOW_LOG
    ADD CONSTRAINT FK_CASH_FLOW_LOG_email_USER_email FOREIGN KEY (email)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE CASH_FLOW_LOG
    ADD CONSTRAINT FK_CASH_FLOW_LOG_sender_USER_email FOREIGN KEY (sender)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE CASH_FLOW_LOG
    ADD CONSTRAINT FK_CASH_FLOW_LOG_receiver_USER_email FOREIGN KEY (receiver)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- NFT_FLOW_LOG Table Create SQL
CREATE TABLE IF NOT EXISTS NFT_FLOW_LOG
(
    `id`        INT            NOT NULL    AUTO_INCREMENT, 
    `email`     VARCHAR(45)    NOT NULL    COMMENT '사용자 이메일', 
    `nftID`     VARCHAR(45)    NOT NULL    COMMENT 'NFT 아이디', 
    `gubun`     CHAR(1)        NOT NULL    COMMENT '거래구분(0:매수, 1:매도, 2:선물받음, 3:선물보냄)', 
    `volume`    INT            NOT NULL    COMMENT '거래 수량', 
    `date`      DATETIME       NOT NULL    COMMENT '거래일(년월일시분초)', 
    `sender`    VARCHAR(45)    NOT NULL    COMMENT '보낸 사람', 
    `receiver`  VARCHAR(45)    NOT NULL    COMMENT '받는 사람', 
    CONSTRAINT PK_NFTFLOWLOG PRIMARY KEY (id)
);

ALTER TABLE NFT_FLOW_LOG COMMENT 'NFT 거래 로그_끝';

ALTER TABLE NFT_FLOW_LOG
    ADD CONSTRAINT FK_NFT_FLOW_LOG_sender_USER_email FOREIGN KEY (sender)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE NFT_FLOW_LOG
    ADD CONSTRAINT FK_NFT_FLOW_LOG_receiver_USER_email FOREIGN KEY (receiver)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE NFT_FLOW_LOG
    ADD CONSTRAINT FK_NFT_FLOW_LOG_email_USER_email FOREIGN KEY (email)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- USER_CASH_ASSET Table Create SQL
CREATE TABLE IF NOT EXISTS USER_CASH_ASSET
(
    `id`       INT            NOT NULL    AUTO_INCREMENT, 
    `email`    VARCHAR(45)    NOT NULL    COMMENT '사용자 이메일', 
    `balance`  VARCHAR(45)    NOT NULL    COMMENT '보유 금액', 
    CONSTRAINT PK_USER_CASH_ASSET PRIMARY KEY (id)
);

ALTER TABLE USER_CASH_ASSET COMMENT '사용자가 가진 NFT 자산';

ALTER TABLE USER_CASH_ASSET
    ADD CONSTRAINT FK_USER_CASH_ASSET_email_USER_email FOREIGN KEY (email)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- FUNDING_MONITOR Table Create SQL
CREATE TABLE IF NOT EXISTS FUNDING_MONITOR
(
    `id`       INT            NOT NULL    AUTO_INCREMENT, 
    `email`    VARCHAR(45)    NULL        COMMENT '사용자 이메일', 
    `nftID`    VARCHAR(45)    NULL        COMMENT 'NFT 아이디', 
    `volume`   INT            NULL        COMMENT '투자 갯수', 
    `balance`  INT            NULL        COMMENT '투자 금액', 
     PRIMARY KEY (id)
);

ALTER TABLE FUNDING_MONITOR COMMENT '계정별 현재 펀딩현황(NFT 자산현황과 다름)';

ALTER TABLE FUNDING_MONITOR
    ADD CONSTRAINT FK_FUNDING_MONITOR_email_USER_email FOREIGN KEY (email)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- PRODUCT_BUY_MONITOR Table Create SQL
CREATE TABLE IF NOT EXISTS PRODUCT_BUY_MONITOR
(
    `id`         INT            NOT NULL    AUTO_INCREMENT, 
    `email`      VARCHAR(45)    NULL        COMMENT '사용자 이메일', 
    `productID`  INT            NULL        COMMENT '굿즈아이디', 
    `isPaid`     CHAR(1)        NULL        COMMENT '금액지불여부(무통장일경우 0)', 
     PRIMARY KEY (id)
);

ALTER TABLE PRODUCT_BUY_MONITOR COMMENT 'NFT 음원 굿즈 거래현황';

ALTER TABLE PRODUCT_BUY_MONITOR
    ADD CONSTRAINT FK_PRODUCT_BUY_MONITOR_email_USER_email FOREIGN KEY (email)
        REFERENCES USER (email) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE PRODUCT_BUY_MONITOR
    ADD CONSTRAINT FK_PRODUCT_BUY_MONITOR_productID_PRODUCT_productID FOREIGN KEY (productID)
        REFERENCES PRODUCT (productID) ON DELETE RESTRICT ON UPDATE RESTRICT;


