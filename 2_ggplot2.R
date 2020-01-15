### -- ggplot2 section
### -- By - Auriel Fournier
### -- https://github.com/aurielfournier/GERS2018

# use install.packages() if you don't have these already
library(dplyr)
library(ggplot2) 
library(ggthemes)
library(RColorBrewer)
library(cowplot)

a_states <- c("AR","AZ","AK","AL")

abird <- read.csv("eBird_workshop.csv") %>%
            filter(state %in% a_states)

# ggplot2 is built on the grammar of graphics, the idea that any plot can be expressed from the same set of components: 

#------ a **data** set
#------ a **coordinate system**
#------ and a set of **geoms** --the visual representation of data points.

# The key to understanding ggplot2 is thinking about a figure in layers. This idea may be familiar to you if you have used image editing programs like Photoshop, Illustrator, or Inkscape.
# Let's start off with an example:

ggplot(data = abird, 
       aes(x = presence, y = samplesize))

# this gives us a plot, with no data on it, but for a good reason. 
# we have told ggplot what data we want to use, and what axis we want
# the variables to be on, but we haven't told it how we want the data displayed
# do we want points? lines? box plots? it has no idea
# so it gives us the blank canvas
# so lets add a layer

ggplot(data = abird, 
       aes(x = presence, y = samplesize)) +
  geom_point()

# now we can see the data! huzzah!
# we use a '+' sign to connect layers in ggplot, instead of the %>% pipe that we 
# learned earlier. I realize this can be confusing



# lets go into a bit more detail of what the above code says
# We've passed in two arguments to `ggplot`. First, we tell `ggplot` what data we
# want to show on our figure, in this example the gapminder data we read in
# earlier. 
# For the second argument we passed in the `aes` function, which
# tells `ggplot` how variables in the **data** map to *aesthetic* properties of
# the figure, in this case the **x** and **y** variables. 
# Here we told `ggplot` we want to plot the "gdpPercap" column of the gapminder 
# data frame on the x-axis, and the "lifeExp" column on the y-axis. 
# Notice that we didn't need to explicitly pass `aes` these columns (e.g. `x = gapminder[, "gdpPercap"]`), this is because `ggplot` is smart enough to know to look in the **data** for that column!

# What do we need to change to look at how sample size changes over time?  

ggplot(data = abird, 
       aes(x = year, y = samplesize)) + 
  geom_point()



### Challenge 2 

# In the previous examples and challenge we've used the `aes` function to tell
# the scatterplot **geom** about the **x** and **y** locations of each point.
# Another *aesthetic* property we can modify is the point *color*. Modify the
# code from the previous challenge to **color** the points by the "continent"
# column. What trends do you see in the data? Are they what you expected?

ggplot(data = abird, 
       aes(x = year, y = samplesize,
           color=state)) + 
  geom_point()


############################
# ---- Layers
############################


#Using a scatterplot probably isn't the best for visualising change over time.
#Instead, let's tell `ggplot` to visualise the data as a line plot:
  
ggplot(data = abird, 
       aes(x=year, y=samplesize)) +
  geom_line()

#Instead of adding a `geom_point` layer, we've added a `geom_line` layer. 
# but this probably doesn't look the way we expect
# since we have the lines colored by continent, there is one line per continent,
# so all the countries in that continent are merged together
# if we add the **by** *aesthetic*, we will be able to say do each line
# by country, and see a different chart

ggplot(data = abird, 
       aes(x=year, y=samplesize,
           color=state)) +
  geom_line()

# But what if we want to visualise both lines and points on the plot? 
# We can simply add another layer to the plot:
  
ggplot(data = abird, 
       aes(x=year, y=samplesize,
           color=state)) +
  geom_line() + 
  geom_point()

#It's important to note that each layer is drawn on top of the previous layer. In
#this example, the points have been drawn *on top of* the lines. Here's a
#demonstration:
  
ggplot(data = abird, 
       aes(x=year, y=samplesize)) +
  geom_line(aes(color=state)) + 
  geom_point()

# In this example, the *aesthetic* mapping of **color** has been moved from the
# global plot options in `ggplot` to the `geom_line` layer so it no longer applies
# to the points. Now we can clearly see that the points are drawn on top of the
# lines.

# Switch the order of the point and line layers from the previous example. What happened?

  ## Transformations and statistics
  
#  ggplot also makes it easy to overlay statistical models over the data. To
# demonstrate we'll go back to our first example:

ggplot(data = abird, 
       aes(x = presence, 
           y = samplesize, 
           color=state)) +
  geom_point()

# Currently it's hard to see the relationship between the points due to some strong
# outliers in GDP per capita. We can change the scale of units on the x axis using
# the *scale* functions. These control the mapping between the data values and
# visual values of an aesthetic. We can also modify the transparency  of the
# points, using the *alpha* funtion, which is especially helpful when you have
# a large amount of data which is very clustered.

ggplot(data = abird, 
       aes(x = presence, 
           y = samplesize, 
           color=state)) +
  geom_point() + 
  scale_x_log10()  

# The `log10` function applied a transformation to the values of the gdpPercap
# column before rendering them on the plot, so that each multiple of 10 now only
# corresponds to an increase in 1 on the transformed scale, e.g. a GDP per capita
# of 1,000 is now 3 on the y axis, a value of 10,000 corresponds to 4 on the y
# axis and so on. This makes it easier to visualise the spread of data on the
# x-axis.

# We can fit a simple relationship to the data by adding another layer,
#`geom_smooth`:
  
ggplot(data = abird, 
  aes(x = presence, y = samplesize)) +
  geom_point(alpha=0.5)+
  geom_smooth(method="lm", aes(color=state))

# We can make the line thicker by *setting* the **size** aesthetic in the
# `geom_smooth` layer:
  
ggplot(data = abird, 
       aes(x = presence, y = samplesize)) +
  geom_point(alpha=0.5)+
  geom_smooth(method="lm", aes(color=state), size=2)

# There are two ways an *aesthetic* can be specified. Here we *set* the **size**
#  aesthetic by passing it as an argument to `geom_smooth`. Previously in the
# lesson we've used the `aes` function to define a *mapping* between data
# variables and their visual representation.

# ## Challenge 4a

# Make a point graph of sample size by presence where all the points are red. 
#

ggplot(data = abird, 
       aes(x = samplesize, y = presence)) +
  geom_point(color="red", size=2) 
## Challenge 4b 
#
# Modify your solution  that the points are now a different shape and are colored by state.

ggplot(data = abird, 
       aes(x = samplesize, y = presence)) +
  geom_point(size=2, aes(shape=state, color=state)) 

#  Hint: The color argument can be used inside and outside the aesthetic 'aes()'.



## Multi-panel figures

# Earlier we visualised the change in life expectancy over time across all
# countries in one plot. Alternatively, we can split this out over multiple panels
# by adding a layer of **facet** panels. Focusing only on those countries with
# names that start with the letter "A" or "Z".

ggplot(data=abird, 
       aes(x = year, 
           y = samplesize, 
           group=state, color=state)) +
  geom_line() + 
  facet_wrap(~state, ncol=2)

# The `facet_wrap` layer took a "formula" as its argument, denoted by the tilde
# (~). This tells R to draw a panel for each unique value in the country column
# of the gapminder dataset.

## Modifying text

# To clean this figure up for a publication we need to change some of the text
# elements. The x-axis is too cluttered, and the y axis should read
# "Life expectancy", rather than the column name in the data frame.

# We can do this by adding a couple of different layers. The **theme** layer
# controls the axis text, and overall text size, and there are special layers
# for changing the axis labels. To change the legend title, we need to use the
# **scale** layer.

ggplot(data=abird, 
       aes(x = year, 
           y = samplesize, 
           group=state, color=state)) +
  geom_line() + 
  facet_wrap(~state, ncol=2) + 
    xlab("Year") + 
    ylab("Sample Size") + 
    ggtitle("Figure 1") +
    scale_colour_discrete(name="State") +
    theme_few()


# This is a taste of what you can do with `ggplot2`. RStudio provides a
# really useful cheat sheet of the different layers available, and more
# extensive documentation is available on the [ggplot2 website][ggplot-doc].
# Finally, if you have no idea how to change something, a quick google search will
# usually send you to a relevant question and answer on Stack Overflow with reusable
# code to modify!

# http://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
# http://docs.ggplot2.org/current/



# you can build your own themes (we'll cover this later)
# OR you can use some pre made themes
# https://github.com/jrnold/ggthemes

ggplot(data=abird, 
       aes(x = year, 
           y = samplesize, 
           group=state, color=state)) +
  geom_line() + 
  facet_wrap(~state, ncol=2)+
  theme_economist()

ggplot(data=abird, 
       aes(x = year, 
           y = samplesize, 
           group=state, color=state)) +
  geom_line() + 
  facet_wrap(~state, ncol=2)+
  theme_gdocs()

ggplot(data=abird, 
       aes(x = year, 
           y = samplesize, 
           group=state, color=state)) +
  geom_line() + 
  facet_wrap(~state, ncol=2)+
  theme_excel()

## Custom Themes

?theme # shows you all the little things you can manipulate in a ggplot
# thus far I've always been able to get done what needs doing with a custom theme
# look at the graph below, its pretty visually assualting
# figure out how to fix it

ggplot(data=abird, 
       aes(x = year, 
           y = samplesize, 
           group=state, color=state)) +
  geom_line() + 
  facet_wrap(~state, ncol=2)+
  ylab("Life Expectancy")+
  theme(axis.text.x = element_text(size = 15, ang=90, color = "purple"), 
        axis.text.y = element_text(size = 2, color = "red"), 
        axis.title.y = element_text(size = 20), 
        plot.background = element_rect(fill="green"), 
        panel.background = element_rect(fill="red", color="black"), 
        panel.grid.major = element_line(colour = "red"), 
        panel.grid.minor = element_line(colour = "purple"), 
        title = element_text(size = 1), 
#        axis.line.x = element_line(colour = "black"), 
#        axis.line.y = element_line(colour = "black"), 
        strip.background = element_rect(fill = "orange", color = "black"), 
        strip.text = element_text(size = 15, color="red"),
        legend.background = element_rect(fill="black"),
        legend.text = element_text(color="gray"),
        legend.key=element_rect(fill="white"))
  


######################
# Colors (RColorBrewer)
#####################
#http://colorbrewer2.org/
  
display.brewer.all(n=NULL, type="all", select=NULL, exact.n=TRUE,colorblindFriendly=TRUE)
  
mypalette<-brewer.pal(4,"Greens")

ggplot(data=abird, 
       aes(x=state, 
          y=samplesize, 
           fill=state)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + 
  scale_fill_manual(values=mypalette)

mypalette<-brewer.pal(4,"Set2")

mypalette[2] <- "#000000"

ggplot(data=abird, 
       aes(x=state, 
           y=samplesize, 
           fill=state)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + 
  scale_fill_manual(values=mypalette)


###################################
## Saving, Stacking and Rearranging Graphs 
###################################

(one <-   ggplot(data=abird, 
               aes(x=year, y=samplesize, group=state)) + 
  geom_line()+
        theme(axis.text.x=element_text(ang=90)))

(two <- ggplot(data=abird, 
             aes(x=samplesize, y=presence)) + 
    geom_point())


left <- plot_grid(one, two, nrow=2, align="hv")

#ggsave(a, file="filenamehere.extension")
ggsave(left, file="~/../Desktop/left.jpeg", 
       height=4, width=4, units="cm", dpi=600)

