<?php

class InteractivePropertyPage extends Page
{
    public static $db = array();

    //static $defaults = array('EventCount' => 0, 'EventsPerPage' => 0, 'ShowMultiDayOnce' => false);

    private static $has_one = array(
        'Location' => 'Location'
    );

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();

        $location = DropdownField::create('LocationID')
            ->setSource(Location::get()->map('ID', 'Title'))
            ->setDescription('Properties ')
            ->setEmptyString('Please select the location');


        $fields->addFieldToTab('Root.Main', $location);

        /*
        $eventArchives = CheckboxSetField::create('EventArchives')
            ->setSource(EventArchive::get()->map('ID', 'Title'))
            ->setDescription('Filter by selected EventArchives');
        $fields->addFieldToTab('Root.Main', $eventArchives);

        $fields->addFieldToTab('Root.Main', DropdownField::create(
            'Grouping',
            'Grouping',
            array(
                'byDay' => 'By day',
                'byWeek' => 'By week',
                'byWeekDay' => 'By week/weekday',
                'byMonth' => 'By month',
                'byYear' => 'By year',
            )
        ));

        $fields->addFieldToTab('Root.Main', DropdownField::create(
            'Timeframe',
            'Timeframe',
            array(
                'lastMonth' => 'Last Month',
                'currentMonth' => 'Current Month',
                'nextMonth' => 'Next Month',
                'lastYear' => 'Last Year',
                'currentYear' => 'Current Year',
                'nextYear' => 'Next Year',
                'past' => 'Past events',
                'future' => 'Future events',
                'all' => 'All events',
            )
        ));

        $fields->addFieldToTab('Root.Main', CheckboxField::create(
            'AllowTimeframeNavigation',
            'Allow month/year navigation'
        )->setDescription('Allows the user to navigate through the months/years.'));

        $fields->addFieldToTab('Root.Main', CheckboxField::create(
            'ShowMultiDayOnce',
            'Show events that span multiple days only once (on the first day)'
        ));

        $conf = GridFieldConfig_RelationEditor::create();
        $fields->addFieldToTab('Root.Main', new GridField('TagFilter', 'Tag filter', $this->TagFilter(), $conf));
        **/

        return $fields;
    }


}

class InteractivePropertyPage_Controller extends Page_Controller
{

    public function init()
    {

        parent::init();
    }


    public function index(SS_HTTPRequest $request)
    {
        Requirements::javascript(FRAMEWORK_DIR . '/thirdparty/jquery/jquery.js');
        Requirements::javascript(FRAMEWORK_DIR . '/thirdparty/jquery-entwine/dist/jquery.entwine-dist.js');
        Requirements::javascript(PROPERTYMANAGER_DIR . '/vendor/tooltipster/tooltipster.bundle.min.js');
        Requirements::javascript(PROPERTYMANAGER_DIR . '/vendor/maphilight/jquery.maphilight.min.js');
        Requirements::css(PROPERTYMANAGER_DIR . '/vendor/tooltipster/tooltipster.bundle.min.css');
        Requirements::css(PROPERTYMANAGER_DIR . "/css/propertymanager.css");

        $buildings = array();
        $buildingFloors = array();

        $dynamicCSS = '';
        
        foreach ($this->Location()->Buildings() as $building) {


            $buildingID = $building->ID;

            @$buildings[$buildingID] = array(
                'ID' => $buildingID,
                'OffsetX' => $building->BuildingOffsetX,
                'OffsetY' => $building->BuildingOffsetY,
                'AnimationOffsetX' => $building->AnimationOffsetX,
                'AnimationOffsetY' => $building->AnimationOffsetY,
                'RoofOffsetX' => $building->RoofOffsetX,
                'RoofOffsetY' => $building->RoofOffsetY,
                'RoofAnimationOffsetX' => $building->RoofAnimationOffsetX,
                'RoofAnimationOffsetY' => $building->RoofAnimationOffsetY,
            );

            // writing css based on configuration
            $dynamicCSS .= '#building-' . $buildingID . '.building-overlay { left: ' . $building->BuildingOffsetX . 'px; top: ' . $building->BuildingOffsetY . ' } ';
            $dynamicCSS .= '#building-' . $buildingID . ' .floor-overlay.offset{
                left: ' . $building->AnimationOffsetX . 'px;  top: ' . $building->AnimationOffsetY . 'px; } ';
            $dynamicCSS .= '#roof-' . $buildingID . '.building-overlay { left: ' . $building->RoofOffsetX . 'px; top: ' . $building->RoofOffsetY . ' } ';
            $dynamicCSS .= '#building-' . $buildingID . ' .roof-overlay.offset {
                left: ' . $building->RoofAnimationOffsetX . 'px !important;  top: ' . $building->RoofAnimationOffsetY . 'px !important; } ';



            foreach ($building->Floors() as $floor) {
                @$buildingFloors[$buildingID][] = array($floor->ID);
            }

        }


        /**
         * var_dump($buildings);
         * var_dump($buildingFloors);
         **/

        $buildingsJSON = json_encode($buildings);
        $buildingFloorsJSON = json_encode($buildingFloors);



        $data = array(
            'PROPERTYMANAGER_DIR' => PROPERTYMANAGER_DIR,
            'LocationBackground' => $this->Location()->BackgroundImage(),
            'LocationBackgroundURL' => $this->Location()->BackgroundImage()->URL,
            'LocationBackgroundWidth' => $this->Location()->BackgroundImage()->getWidth(),
            'LocationBackgroundHeight' => $this->Location()->BackgroundImage()->getHeight(),


            'DynamicCSS' => $dynamicCSS,
            'BuildingsJSON' => $buildingsJSON,
            'BuildingFloorsJSON' => $buildingFloorsJSON,


            'BuildingsData' => $this->Location()->Buildings()

        );

        return $this->customise($data)->renderWith(array('InteractivePropertyPage', 'Page'));

    }


}