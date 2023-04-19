module Main exposing (main)

import Article
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { tags : List String
    , selectedTag : String

    {- Removed Article type annotation and created down below 
    -}
    , allArticles : List Article
    }

    -- Created type alias Article so allArticles can be a List of Articles
type alias Article =
    { title : String
    , description : String
    , body : String
    , tags : List String
    , slug : String
    }


{-| No Arugments only returns a Model?
-}
initialModel : Model
initialModel =
    { tags = Article.tags
    , selectedTag = "elm"
    , allArticles = Article.feed
    }



-- UPDATE


type alias Msg =
    { description : String
    , data : String
    }

{-| takes a Msg alias { description : String, data : String } 
Returns function that updates model if msg.description == "ClickedTag" or returns the existing model
-}
update : Msg -> Model -> Model
update msg model =
    if msg.description == "ClickedTag" then
        { model | selectedTag = msg.data }

    else
        model



-- VIEW


{-| View takes in a model and returns the DOMs? Html Msg? 
-}
view : Model -> Html Msg
view model =
    let
        articles =
            List.filter (\article -> List.member model.selectedTag article.tags)
                model.allArticles

        feed =
            List.map viewArticle articles
    in
    div [ class "home-page" ]
        [ viewBanner
        , div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-9" ] feed
                , div [ class "col-md-3" ]
                    [ div [ class "sidebar" ]
                        [ p [] [ text "Popular Tags" ]
                        , viewTags model
                        ]
                    ]
                ]
            ]
        ]


{-| viewArticle takes in an Article and returns Html Msg/Dom/Html formatting etc
-}
viewArticle : Article -> Html Msg
viewArticle article =
    div [ class "article-preview" ]
        [ h1 [] [ text article.title ]
        , p [] [ text article.description ]
        , span [] [ text "Read more..." ]
        ]


{-| Doesn't take any arugments? Only returns Html Msg?
-}
viewBanner : Html Msg
viewBanner =
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [ class "logo-font" ] [ text "conduit" ]
            , p [] [ text "A place to share your knowledge." ]
            ]
        ]


{-| Trying to figure out what arguments this function takes and returns It starts off with an Article and assigns a tag value of either selected or default
There are multiple ways of doing this it can also be 
viewTag : String -> String -> Html Msg
viewTag selectedTagName tagName
or 
viewTag : { selectedTagName String -> tagName String } -> Html Msg
viewTag { selectedTagName tagName } =
What's ideal in this situation???
-}
viewTag : String -> String -> Html { description : String, data : String }
viewTag selectedTagName tagName =
    let
        otherClass =
            if tagName == selectedTagName then
                "tag-selected"

            else
                "tag-default"
    in
    button
        [ class ("tag-pill " ++ otherClass)
        , onClick { description = "ClickedTag", data = tagName }
        ]
        [ text tagName ]


viewTags : Model -> Html Msg
viewTags model =
    div [ class "tag-list" ] (List.map (viewTag model.selectedTag) model.tags)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
