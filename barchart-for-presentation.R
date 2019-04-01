# Model 1 (not critical)

par(mfrow=c(3,2),oma = c(5,10,5,10),  mar = c(0,0,2,1))
pie(c(1227,13100),cex=2.5, cex.main = 2, col=c("#D3D3D3","white"),main="Not Critical of Testing Model",labels=c("9%",""),radius = 0.8, init.angle=350)
#segments(x0 = .75,y0 = .27,x1 =10, y1 = -1 )
#segments(0.75,-.18,10,1)
pie(c(378,849), cex=2.5,cex.main = 2,  col=c("black","white"),main="Precision",labels=c("31%",""),radius = 0.5, init.angle=350)
#segments(x0 = -.9,y0 = .07,x1 =-.5, y1 = 0)
#segments(x0 = -.9,y0 = -.07,x1 =-.5, y1 = 0)


# Model 2 (pro-testing) # 470 responses classified

#par(mfrow=c(1,2),oma = c(5,12,5,12),  mar = c(0,0,1,1))
pie(c(470,13100), cex=2.5,cex.main = 2, col=c("#D3D3D3","white"),main="In Favor of Testing Model",labels=c("3.5%",""),radius = 0.8, init.angle=350)
#segments(x0 = .75,y0 = .27,x1 =10, y1 = -1 )
#segments(0.75,-.18,10,1)
pie(c(168,6,296), cex=2.5,cex.main = 2, col=c("black","#787878","white"),main="Precision",labels=c("36%",""),radius = 0.5, init.angle=350)
#segments(x0 = -.9,y0 = .07,x1 =-.5, y1 = 0)
#segments(x0 = -.9,y0 = -.07,x1 =-.5, y1 = 0)

# Model 3 (encouraging) 

#par(mfrow=c(1,2),oma = c(5,12,5,12),  mar = c(0,0,1,1))
pie(c(128,13100), cex=2.5,cex.main = 2, col=c("#D3D3D3","white"),main="Encouraging Model",labels=c("1%",""),radius = 0.8, init.angle=350)
#segments(x0 = .75,y0 = .27,x1 =10, y1 = -1 )
#segments(0.75,-.18,10,1)
pie(c(68,16,44), cex=2.5,cex.main = 2, col=c("black","#787878","white"),main="Precision",labels=c("53%",""),radius = 0.5, init.angle=350)
#segments(x0 = -.9,y0 = .07,x1 =-.5, y1 = 0)
#segments(x0 = -.9,y0 = -.07,x1 =-.5, y1 = 0)
