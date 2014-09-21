data(mtcars)
shinyUI(fluidPage(
    titlePanel("Relationship between MPG and other car characteristics"),
    fluidRow(
        column(3,
            selectizeInput(
                "vars", "Variables",
                choices = sort(names(mtcars)[-1]),
                multiple=T,
                options = list(
                    placeholder = 'Select one or more variables',
                    onInitialize = I('function() { this.setValue(""); }')))),
        column(3,
            checkboxInput("intercept", "Include intercept", value=T),
            helpText("Select parameters for the regression"))),
    fluidRow(
        column(12,
            tabsetPanel(
                tabPanel(
                    "Regression",
                    h2("Coefficients"),
                    htmlOutput('coef'),
                    h2("Statistics"),
                    htmlOutput('stats')),
                tabPanel("Data", dataTableOutput('tbl')),
#                tabPanel("Debug", verbatimTextOutput("dbg")),
                tabPanel("Documentation", includeMarkdown("documentation.md")))))))
