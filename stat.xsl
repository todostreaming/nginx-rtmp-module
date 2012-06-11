<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:template match="/">
    <html>
        <head>
            <title>RTMP statistics</title>
        </head>
        <body>
            <xsl:apply-templates select="rtmp"/>
            <hr/>
            Generated by <a href='https://github.com/arut/nginx-rtmp-module'>NGINX RTMP module</a>,
            <a href="http://nginx.com">NGINX</a>&#160;<xsl:value-of select="/rtmp/version"/>,
            built <xsl:value-of select="/rtmp/built"/>&#160;<xsl:value-of select="/rtmp/compiler"/>
        </body>
    </html>
</xsl:template>

<xsl:template match="rtmp">
    <table cellspacing="1" cellpadding="5">
        <tr bgcolor="#999999">
            <th>RTMP</th>
            <th>#clients</th>
            <th>In bytes</th>
            <th>Out bytes</th>
            <th>In Kbps</th>
            <th>Out Kbps</th>
            <th>Size</th>
            <th>Frame Rate</th>
            <th>Video</th>
            <th>Audio</th>
            <th>State</th>
            <th>Time</th>
        </tr>
        <tr>
            <td colspan="2"/>
            <td><xsl:value-of select="in"/></td>
            <td><xsl:value-of select="out"/></td>
            <td><xsl:value-of select="round(bwin div 1024)"/></td>
            <td><xsl:value-of select="round(bwout div 1024)"/></td>
        </tr>
        <xsl:apply-templates select="server"/>
    </table>
</xsl:template>

<xsl:template match="server">
    <xsl:apply-templates select="application"/>
</xsl:template>

<xsl:template match="application">
    <tr bgcolor="#999999">
        <td>
            <b><xsl:value-of select="name"/></b>
        </td>
    </tr>
    <xsl:apply-templates select="live"/>
</xsl:template>

<xsl:template match="live">
    <tr bgcolor="#aaaaaa">
        <td>
            <i>live streams</i>
        </td>
        <td align="middle">
            <xsl:value-of select="nclients"/>
        </td>
    </tr>
    <xsl:apply-templates select="stream"/>
</xsl:template>

<xsl:template match="stream">
    <tr valign="top" bgcolor="#cccccc">
        <td>
            <a href="">
                <xsl:attribute name="onclick">
                    var d=document.getElementById('<xsl:value-of select="../../name"/>-<xsl:value-of select="name"/>');
                    d.style.display=d.style.display=='none'?'':'none';
                    return false
                </xsl:attribute>
                <xsl:value-of select="name"/>
                <xsl:if test="string-length(name) = 0">
                    [EMPTY]
                </xsl:if>
            </a>
        </td>
        <td align="middle"> <xsl:value-of select="nclients"/> </td>
        <td><xsl:value-of select="in"/></td>
        <td><xsl:value-of select="out"/></td>
        <td><xsl:value-of select="round(bwin div 1024)"/></td>
        <td><xsl:value-of select="round(bwout div 1024)"/></td>
        <td><xsl:value-of select="meta/width"/>x<xsl:value-of select="meta/height"/></td>
        <td align="middle"><xsl:value-of select="meta/framerate"/></td>
        <td><xsl:value-of select="meta/video"/></td>
        <td><xsl:value-of select="meta/audio"/></td>
        <td> <xsl:apply-templates select="publishing"/> </td>
        <td>
            <xsl:call-template name="showtime">
               <xsl:with-param name="time" select="time"/>
            </xsl:call-template>
        </td>
    </tr>
    <tr style="display:none">
        <xsl:attribute name="id">
            <xsl:value-of select="../../name"/>-<xsl:value-of select="name"/>
        </xsl:attribute>
        <td colspan="7" ngcolor="#eeeeee">
            <table cellspacing="1" cellpadding="5">
                <tr>
                    <th>State</th>
                    <th>Address</th>
                    <th>Flash version</th>
                    <th>Page URL</th>
                    <th>Dropped</th>
                    <th>A-V</th>
                    <th>Time</th>
                </tr>
                <xsl:apply-templates select="client"/>
            </table>
        </td>
    </tr>
</xsl:template>

<xsl:template name="showtime">
    <xsl:param name="time"/>

    <xsl:variable name="sec">
        <xsl:value-of select="floor(time div 1000)"/>
    </xsl:variable>

    <xsl:if test="$sec &gt;= 86400">
        <xsl:value-of select="(floor($sec div 86400)) mod 60"/>d
    </xsl:if>

    <xsl:if test="$sec &gt;= 3600">
        <xsl:value-of select="(floor($sec div 3600)) mod 60"/>h
    </xsl:if>

    <xsl:if test="$sec &gt;= 60">
        <xsl:value-of select="(floor($sec div 60)) mod 60"/>m
    </xsl:if>

    <xsl:value-of select="$sec mod 60"/>s
</xsl:template>


<xsl:template match="client">
    <tr bgcolor="#eeeeee">
        <td><xsl:apply-templates select="publishing"/></td>
        <td><xsl:value-of select="address"/></td>
        <td><xsl:value-of select="flashver"/></td>
        <td>
            <a target="_blank">
                <xsl:attribute name="href">
                    <xsl:value-of select="pageurl"/>
                </xsl:attribute>
                <xsl:value-of select="pageurl"/>
            </a>
        </td>
        <td><xsl:value-of select="dropped"/></td>
        <td><xsl:value-of select="avsync"/></td>
        <td>
            <xsl:call-template name="showtime">
               <xsl:with-param name="time" select="time"/>
            </xsl:call-template>
        </td>
    </tr>
</xsl:template>

<xsl:template match="publishing">
    publishing
</xsl:template>

</xsl:stylesheet>
