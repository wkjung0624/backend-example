-- NFT Table Create SQL
CREATE TABLE NFT
(
    `id`           INT            NOT NULL, 
    `nftID`        INT            NULL, 
    `imgSrc`       VARCHAR(30)    NULL, 
    `musicName`    VARCHAR(45)    NULL, 
    `infoComment`  TEXT           NULL, 
    CONSTRAINT PK_NFT PRIMARY KEY (id)
);


-- USER Table Create SQL
CREATE TABLE USER
(
    `id`             INT            NOT NULL    AUTO_INCREMENT, 
    `email`          VARCHAR(45)    NOT NULL, 
    `name`           VARCHAR(10)    NULL, 
    `pwd`            char(64)       NOT NULL, 
    `phoneVerified`  CHAR(1)        NULL, 
    `bankAccount`    varchar(30)    NULL, 
    CONSTRAINT PK_USER PRIMARY KEY (id)
);

ALTER TABLE USER COMMENT '회원정보';


-- MARKET Table Create SQL
CREATE TABLE MARKET
(
    `id`     INT    NOT NULL    AUTO_INCREMENT, 
    `nftID`  INT    NULL, 
    CONSTRAINT PK_MARKET PRIMARY KEY (id)
);

ALTER TABLE MARKET
    ADD CONSTRAINT FK_MARKET_nftID_NFT_nftID FOREIGN KEY (nftID)
        REFERENCES NFT (nftID) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- ARTIST Table Create SQL
CREATE TABLE ARTIST
(
    `id`       INT            NOT NULL    AUTO_INCREMENT, 
    `name`     VARCHAR(45)    NOT NULL, 
    `comment`  VARCHAR(45)    NULL, 
    CONSTRAINT PK_ARTIST PRIMARY KEY (id)
);


-- NFT_TO_ARTIST Table Create SQL
CREATE TABLE NFT_TO_ARTIST
(
    `id`  INT    NOT NULL    AUTO_INCREMENT, 
    CONSTRAINT PK_NFT_TO_ARTIST PRIMARY KEY (id)
);


-- FUND Table Create SQL
CREATE TABLE FUND
(
    `id`            INT            NOT NULL    AUTO_INCREMENT, 
    `endDate`       DATETIME       NULL, 
    `Artist`        VARCHAR(45)    NULL, 
    `targetAmount`  INT            NULL        COMMENT '목표금액,달성금액', 
    CONSTRAINT PK_FUND PRIMARY KEY (id)
);


-- PRODUCT Table Create SQL
CREATE TABLE PRODUCT
(
    `id`              INT            NOT NULL    AUTO_INCREMENT, 
    `productName`     VARCHAR(45)    NULL        COMMENT '굿즈이름', 
    `productComment`  TEXT           NULL, 
    `imgSrc`          VARCHAR(30)    NULL, 
    CONSTRAINT PK_PRODUCT PRIMARY KEY (id)
);


