<?php

class InputFieldTest extends DataObject
{

    public static $db = array(
        'Title' => 'Varchar',
        'Coordinates' => 'Text',
        'Color' => 'Text',

    );

    public static $has_one = array(
        'Image' => 'Image',
        'TestImage' => 'Image',

    );


    public function getCMSFields()
    {
        $fields = FieldList::create(TabSet::create('Root'));
        //$fields = parent::getCMSFields();

        $fields->addFieldToTab('Root.Main', TextField::create('Title'));


        $upload = ColorField::create('Color', 'Color', '#fff');



        //$upload = ImageMapUploadField::create('ImageMapUploadFieldTest');

        $fields->addFieldToTab('Root.Main', $upload);

        $test = UploadField::create('TestImage');
        $fields->addFieldToTab('Root.Main', $test);


        //FocusPointField::c
        return $fields;
    }




    public function onBeforeWrite()
    {
        parent::onBeforeWrite();



    }

}
