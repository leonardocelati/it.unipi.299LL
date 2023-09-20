<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="html" indent="yes" />
    
    <xsl:variable name="quality" as="xs:integer">1</xsl:variable>
    
    <!-- Root -->
    <xsl:template match="/">
            <xsl:apply-templates select="TEI"/>
    </xsl:template>
    
    <xsl:param name="singleQuote">'</xsl:param>
    <xsl:param name="singelQuoteJS">\\'</xsl:param>
    <xsl:template name="escape-string-js">
        <xsl:param name="str"/>
        <xsl:value-of select="replace($str, $singleQuote, $singelQuoteJS)"/>
    </xsl:template>    
    
    <xsl:template name="personData">
        <xsl:param name="pid"/>
        <xsl:param name="pname"/>
        '<xsl:value-of select="concat('#',$pid)"/>': '<xsl:value-of select="$pname"/>'
    </xsl:template>
    
    <xsl:template name="placeData">
        <xsl:param name="pid"/>
        <xsl:param name="pname"/>
        '<xsl:value-of select="$pid"/>': ['<xsl:value-of select="$pname"/>','<xsl:call-template name="escape-string-js"><xsl:with-param name="str"><xsl:value-of select="desc"/></xsl:with-param></xsl:call-template>','<xsl:value-of select="location/country"/>','<xsl:value-of select="location/region"/>','<xsl:value-of select="location/geo"/>']
    </xsl:template>    
    
    <!-- TEI element -->
    <xsl:template match="TEI">
        <html>
            <head>
                <title><xsl:value-of select="teiHeader/fileDesc/titleStmt/title"/></title>
                
                <xsl:comment>css a caricamento immediato</xsl:comment>
                <style>
                    #diary .page, #graphic .facsimile, #visor .info {
                        display: none
                    }
                </style>
                <link rel="stylesheet" href="assets/style/artom-diary.css"/>
                <xsl:text>&#xa;&#xA;</xsl:text>
                <xsl:comment>Variabili comuni</xsl:comment> 
                <script>
                    diaryData = {
                        pages: [
                            <xsl:for-each select="facsimile/surface"><xsl:sort select="@xml:id"/>
                                '<xsl:value-of select="@xml:id"/>'<xsl:if test="position() != last()">,</xsl:if>
                            </xsl:for-each>
                        ],
                        text: [
                            <xsl:for-each select="text/body/div/div"><xsl:sort select="@facs"/>
                                '<xsl:value-of select="concat(substring-after (@facs,'#'), '-text')"/>'<xsl:if test="position() != last()">,</xsl:if>
                            </xsl:for-each>
                        ],
                        people: {
                            <xsl:for-each select="text/body/listPerson/person">
                                <xsl:call-template name="personData">
                                    <xsl:with-param name="pid"><xsl:value-of select="@xml:id" /></xsl:with-param>
                                    <xsl:with-param name="pname"><xsl:value-of select="persName" /></xsl:with-param>
                                </xsl:call-template>
                                <xsl:if test="position() != last()">,</xsl:if>
                            </xsl:for-each>
                        },
                        places: {
                            <xsl:for-each select="text/body/listPlace/place">
                                <xsl:call-template name="placeData">
                                    <xsl:with-param name="pid"><xsl:value-of select="@xml:id" /></xsl:with-param>
                                    <xsl:with-param name="pname"><xsl:value-of select="placeName" /></xsl:with-param>
                                </xsl:call-template>
                                <xsl:if test="position() != last()">,</xsl:if>
                            </xsl:for-each>                            
                        }

                    }
                </script>
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
                <script type="text/javascript" src="assets/script/artom-script.js"></script>
            </head>
            <body onload="init()">
                
                <xsl:text>&#xa;&#xA;</xsl:text>
                <xsl:comment>Inizio layer grafica</xsl:comment>
                
                <div id="visor">                  
                    <div id="upper-control">
                        <div class="direction" onclick="javascript:moveToPage('left');">left</div>
                        <div class="direction" onclick="javascript:moveToPage('right');">right</div>
                    </div>                    
                    <div id="image"/>
                    <div id="lower-control">
                        <div class="direction" onclick="javascript:moveToPage('left');">left</div>
                        <div class="direction" onclick="javascript:moveToPage('right');">right</div>
                    </div>
                    <div class="info">
                        <div class="container>">
                            <div onclick="toggleInfoPopup()" class="close-btn">chiudi</div>
                            <div class="content"></div>
                        </div>
                    </div>                      
                    <div id="text"/>
                </div>
                
                <xsl:text>&#xa;&#xA;</xsl:text>
                <xsl:comment>Inizio layer grafica</xsl:comment>
                <div id="graphic">
                    <xsl:for-each select="facsimile">
                        <xsl:apply-templates select="surface"/>
                    </xsl:for-each>
                </div>
                <xsl:comment>Fine layer grafica</xsl:comment>
                
                <xsl:text>&#xa;&#xA;</xsl:text>
                <xsl:comment>Inizio layer diario</xsl:comment>
                <div id="diary">
                    
                    <xsl:for-each select="text/body/div[@xml:id='diario']">
                        <xsl:apply-templates select="div"></xsl:apply-templates>
                    </xsl:for-each>
                    
                </div>
                <xsl:comment>Fine layer diario</xsl:comment>
                
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="div">
        <div>
            <xsl:attribute name="id">
                <xsl:value-of select="concat(substring-after (@facs,'#'), '-text')"/>
            </xsl:attribute>
            <xsl:attribute name="class">page</xsl:attribute>
            <xsl:apply-templates select="ab"></xsl:apply-templates>
        </div>
    </xsl:template>    
    
    <!-- template ab -->
    <xsl:template match="ab">
        <div>
            <xsl:apply-templates select="node()"/>
        </div>
    </xsl:template>   
    
    <!-- La lista di persone che compaiono nel testo -->
    <xsl:template match="person">
        <div>
            <xsl:attribute name="id"><xsl:value-of select="@xml:id" /></xsl:attribute>
            <xsl:attribute name="class">person</xsl:attribute>
            <xsl:value-of select="persName"/>
        </div>
    </xsl:template>
    
    <!-- Riferimento a persName nel contenuto del diario -->
    <xsl:template match="persName">
        <span class="person_anchor">
            <xsl:attribute name="onclick">person('<xsl:value-of select="@ref"/>','<xsl:value-of select="."/>')</xsl:attribute><xsl:value-of select="."/>
        </span>
    </xsl:template>     
    
    <!-- Riferimento a placeName nel contenuto del diario -->
    <xsl:template match="placeName">
        <span class="place_anchor">
            <xsl:attribute name="onclick">place('<xsl:value-of select="@ref"/>')</xsl:attribute><xsl:value-of select="."/>
        </span>
    </xsl:template>
    
    <!-- Nel testo è presente e quindi gestito il solo caso cancelled -->
    <xsl:template match="gap">
        <span class="cancelled"/>
    </xsl:template>

    <xsl:template match="del">
        <!--<span class="del"><xsl:apply-templates select="@*|node()"/></span>-->
    </xsl:template>

    <!-- Inizio casi choice -->
    <xsl:template match="choice">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>
    
    <xsl:template match="sic">
        <span class="sic"><xsl:apply-templates select="@*|node()"/></span>
    </xsl:template>
    
    <xsl:template match="corr">
        (<span class="corr"><xsl:apply-templates select="@*|node()"/></span>)
    </xsl:template>
    
    <xsl:template match="abbr">
        <span class="abbr"><xsl:value-of select="."/></span>
    </xsl:template>
    
    <xsl:template match="expan">
        <span class="abbr-content">(abbreviazione di <span class="term"><xsl:value-of select="."/>'</span>)</span>
    </xsl:template>
    <!-- Fine casi choice -->
 
 
    <xsl:template match="add">
        <span class="add"><xsl:value-of select="."/></span>
    </xsl:template>
    

    <xsl:template match="place">
        <div>
            <xsl:attribute name="id"><xsl:value-of select="@xml:id" /></xsl:attribute>
            <xsl:attribute name="class">place</xsl:attribute>
            <span><xsl:value-of select="placeName"/></span>
            <span><xsl:value-of select="desc"/></span>
            <span><xsl:value-of select="location/country"/></span>
            <span><xsl:value-of select="location/region"/></span>
            <span><xsl:value-of select="location/geo"/></span>
        </div>
    </xsl:template>
    
    
    <xsl:template match="surface">
        <xsl:variable name="sid">
            <xsl:value-of select="@xml:id"/>
        </xsl:variable>
        <div>
            <xsl:attribute name="id"><xsl:copy-of select="$sid" /></xsl:attribute>
            <xsl:attribute name="class">facsimile</xsl:attribute>
            <div>
                <xsl:attribute name="class">presentation</xsl:attribute>
                <img>
                    <xsl:attribute name="src">assets/graphic/<xsl:value-of select="/TEI/facsimile/surface[@xml:id=$sid]/graphic[$quality]/@url" /></xsl:attribute>
                </img>
            </div>          
        </div>
    </xsl:template>
    

    <!-- Identity transform -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    
    
    
</xsl:stylesheet>