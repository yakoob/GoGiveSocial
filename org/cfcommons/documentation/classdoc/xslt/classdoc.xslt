<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="1.0">

<xsl:template match="/document/class">
<html>
	<head>
		<title>Root Document</title>
		
		<!-- // include stylesheet reference here -->
		
	</head>
	<body>
	
		<div id="header">
			<!-- // dot-notation path (i.e., package) of the class // -->
			<div><a href="{@package}/index.html"><xsl:value-of select="@package"/></a></div>
			<!-- // "Name" of the class // -->
			<h2><xsl:value-of select="@type"/></h2>
		</div>
		
		<div id="hierarchy">
			<h3>Component Hierarchy</h3>
			<xsl:for-each select="hierarchy/superclass">
				<xsl:call-template name="type-link">
					<xsl:with-param name="package" select="@package"/>
					<xsl:with-param name="type" select="@type"/>
				</xsl:call-template>
			</xsl:for-each>
		</div>
	
		<div id="directly-implemented-interfaces">
			<h3>Directly Implemented Interfaces</h3>
			<xsl:for-each select="interfaces/direct/interface">
				<xsl:value-of select="position()" />-
				<xsl:call-template name="type-link">
					<xsl:with-param name="package" select="@package"/>
					<xsl:with-param name="type" select="@type"/>
				</xsl:call-template>
			</xsl:for-each>
		</div>
		
		<div id="indirectly-implemented-interfaces">
	
			<h3>Indirectly Implemented Interfaces</h3>
				
			<!-- // iterate through each superclass // -->
			<table border="1"><th>Inherited From</th><th>Interface(s)</th><tr>
			<xsl:for-each select="interfaces/inherited/superclass">
							
				<td>
				<xsl:call-template name="type-link">
					<xsl:with-param name="package" select="@package"/>
					<xsl:with-param name="type" select="@type"/>
				</xsl:call-template>
				</td>			
					
				<td>		
				<xsl:for-each select="interface">
					<xsl:call-template name="type-link">
						<xsl:with-param name="package" select="@package"/>
						<xsl:with-param name="type" select="@type"/>
					</xsl:call-template>,	
				</xsl:for-each>
				</td>
							
			</xsl:for-each>
			</tr></table>
			
		</div>
		
		<div id="properties">
	
			<h3>Properties</h3>
				
			<!-- // iterate through each superclass // -->
			<table border="1"><tr>
			<xsl:for-each select="properties/direct/property">
							
				<td>
					<xsl:value-of select="@type"/><xsl:text> </xsl:text>
					<xsl:value-of select="@name"/>
				</td>			
					
				<td>		
					<xsl:for-each select="attr">
						<xsl:value-of select="key"/><xsl:text> </xsl:text>
						<xsl:value-of select="value"/>,
					</xsl:for-each>
				</td>
							
			</xsl:for-each>
			</tr></table>
			
		</div>
		
		<div id="constructor">
			<h3>Constructor</h3>
			<table border="1"><tr><td>
			<xsl:value-of select="constructor/method/@accessModifier" /><xsl:text> </xsl:text>
			<xsl:value-of select="constructor/method/@returntype" /><xsl:text> </xsl:text>
			<xsl:value-of select="constructor/method/@name" />(<xsl:text> </xsl:text>
			</td></tr></table>			
		</div>
			
	</body>
</html>
		
</xsl:template>

<xsl:template name="type-link">
	<xsl:param name="package" />
	<xsl:param name="type" />
	<a href="{@package}/{@type}.html"><xsl:value-of select="@package" />.<xsl:value-of select="@type"/></a>
</xsl:template>

</xsl:stylesheet>