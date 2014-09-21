data(mtcars)
library(data.table)
library(xtable)
mtcars <- as.data.table(mtcars)
mtcars[,cyl:=factor(cyl)][,am:=factor(am)][,gear:=factor(gear)][,carb:=factor(carb)][,vs:=factor(vs)]

shinyServer(function(input, output) {
    fit <- reactive({
        ftext <- paste("mpg ~",if(length(input$vars)) paste(input$vars, collapse="+") else ".", if(input$intercept) "" else "-1")
        lm(as.formula(ftext), data=mtcars)
    })
    sumr <- reactive({
        summary(fit())
    })
    output$coef <- renderPrint(print(xtable(fit()), type='html'))
    output$stats <- renderPrint({
        s = sumr()
        t <- xtable(data.frame(`Value`=c(`Multiple R-squared`=s$r.squared,
                                         `Adjusted R-squared`=s$adj.r.squared,
                                         `Residual standard error`=sqrt(sum(s$residuals^2)/s$df[2]),
                                         `F-statistic`=s$fstatistic[[1]])))
        print(t, type='html')
        })
    output$tbl <- renderDataTable(mtcars)
    output$dbg <- renderPrint(list(vars=input$vars, intercept=input$intercept, fit=fit(), sumr=sumr()))
})

function(input, output) {
    selection <- reactive({
        dms[Account %in% input$pf & Breakdown %in% input$bd, list(Portfolio=Account, Category, Percent=Portfolio/100.0)]
    })
    output$nrows <- reactive({ nrow(selection()) })
    outputOptions(output, 'nrows', suspendWhenHidden=FALSE)
    cast_selection <- reactive({
        d <- selection()
        if (nrow(d))
            dcast.data.table(selection(), Category~Portfolio, value.var="Percent", fill=0)
        else NULL
    })
    output$tbl <- renderDataTable(cast_selection())
    output$dbg <- renderPrint(list(pf=input$pf, bd=input$bd))
    output$fign <- renderChart({
        fig <- nPlot(
            Percent ~ Category,  group='Portfolio', data=selection(),
            dom="fign", type="multiBarHorizontalChart")
        fig$chart(showControls=F, margin=list(left = 200))
        fig$yAxis(tickFormat = "#!d3.format('.2%')!#")
        return(fig)
    })
    output$figd <- renderChart2({
        d <- selection()
        if (nrow(d)==0) return(NULL)
        fig <- dPlot(
            x="Percent", y=c("Category", "Portfolio"), groups='Portfolio', data=d,
            type='bar', bounds = list(x=200,y=30,height=320,width=500))
        fig$yAxis(type="addCategoryAxis", orderRule = "Percent")
        fig$xAxis(type="addMeasureAxis", outputFormat=".2%")
        fig$defaultColors(
            latticeExtra::theEconomist.theme()$superpose.line$col,
            replace=T
        )
        fig$legend(
            x = 675,
            y = 10,
            width = 75,
            height = 100,
            horizontalAlign = "left"
        )
        return(fig)
    })
    output$figg <- renderGvis({
        d <- cast_selection()
        if (is.null(d)) return(NULL)
        gvisBarChart(
            d,
            xvar="Category",
            options=list(
                height=500,
                hAxis="{format:'0.##%'}"))
    })
}
