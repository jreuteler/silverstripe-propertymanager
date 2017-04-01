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


        /**
         * $timezone = DateHelper::getUserTimezone($request);
         *
         * $timeframeManager = new TimeframeManager($timezone, $this->AllowTimeframeNavigation);
         * $timeframeManager->setTimeframe($this->Timeframe);
         *
         * $startDate = $timeframeManager->getStartDate();
         * $endDate = $timeframeManager->getEndDate();
         *
         * $navigation = $timeframeManager->getNavigationLinks();
         *
         * if ($navigation) {
         * $data = array(
         * 'TimeframeNavigation' => $this->AllowTimeframeNavigation,
         * 'CurrentPageLink' => Director::get_current_page()->Link(),
         * 'PreviousLink' => $navigation->PreviousLink,
         * 'NextLink' => $navigation->NextLink,
         * 'CurrentLink' => $navigation->CurrentLink,
         * );
         * }
         *
         * $events = EventHelper::getGroupedEvents($startDate, $endDate, $this->Grouping, $this->EventArchives(), $this->TagFilter(), $this->ShowMultiDayOnce);
         * $data['GroupedEvents'] = $events;
         * $data['EventListTitle'] = 'Events grouped by ' . strtolower(substr($this->Grouping, 2));
         *
         *
         **/

        $floorImageMaps = array();
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

            /**
             * $dynamicCSS .= '#building_'.$buildingID.' .floor_overlay.active{
             * left: '.$building->BuildingOffsetX.'px;  top: '.$building->BuildingOffsetY.'px; }';
             **/


            $dynamicCSS .= '#building_' . $buildingID . '.building_overlay { left: ' . $building->BuildingOffsetX . 'px; top: ' . $building->BuildingOffsetY . ' } ';

            $dynamicCSS .= '#building_' . $buildingID . ' .floor_overlay.moved{
                left: ' . $building->AnimationOffsetX . 'px;  top: ' . $building->AnimationOffsetY . 'px; } ';


            $dynamicCSS .= '#roof_' . $buildingID . '.building_overlay { left: ' . $building->RoofOffsetX . 'px; top: ' . $building->RoofOffsetY . ' } ';

            $dynamicCSS .= '#roof_' . $buildingID . '.roof_overlay.moved{
                left: ' . $building->RoofAnimationOffsetX . 'px !important;  top: ' . $building->RoofAnimationOffsetY . 'px !important; } ';


            foreach ($building->Floors() as $floor) {

                @$buildingFloors[$buildingID][] = array($floor->ID);

                $floorImageMaps[$buildingID][$floor->ID] = array(
                    'default' => $floor->OverviewImage()->ImageMapCoordinates,
                    'moved' => ImageMapHelper::calculateOffset($floor->OverviewImage()->ImageMapCoordinates, $building->AnimationOffsetX, $building->AnimationOffsetY)

                );
            }

        }


        /**
         * var_dump($buildings);
         * var_dump($buildingFloors);
         **/

        $buildingsJSON = json_encode($buildings);
        $buildingFloorsJSON = json_encode($buildingFloors);

        $floorImageMapsJSON = json_encode($floorImageMaps);


        var_dump($floorImageMapsJSON);


        $data = array(
            'PROPERTYMANAGER_DIR' => PROPERTYMANAGER_DIR,
            'LocationBackground' => $this->Location()->BackgroundImage(),
            'LocationBackgroundURL' => $this->Location()->BackgroundImage()->URL,
            'LocationBackgroundWidth' => $this->Location()->BackgroundImage()->getWidth(),
            'LocationBackgroundHeight' => $this->Location()->BackgroundImage()->getHeight(),


            'DynamicCSS' => $dynamicCSS,
            'BuildingsJSON' => $buildingsJSON,
            'BuildingFloorsJSON' => $buildingFloorsJSON,

            'FloorImageMapsJSON' => $floorImageMapsJSON,

            'BuildingsData' => $this->Location()->Buildings()

        );

        return $this->customise($data)->renderWith(array('InteractivePropertyPage', 'Page'));

    }


}